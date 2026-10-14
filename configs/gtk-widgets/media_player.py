#!/usr/bin/env python3
"""Retro MPRIS media deck; session D-Bus access runs off the GTK thread."""

import threading
from urllib.parse import unquote, urlparse
from urllib.request import urlopen

from widget import Gdk, GLib, Gtk, Widget
from gi.repository import Gio, Pango

PREFIX = "org.mpris.MediaPlayer2."
PATH = "/org/mpris/MediaPlayer2"
PLAYER = "org.mpris.MediaPlayer2.Player"


def call(bus, name, interface, method, arguments=None):
    return bus.call_sync(
        name,
        PATH if name != "org.freedesktop.DBus" else "/org/freedesktop/DBus",
        interface,
        method,
        arguments,
        None,
        Gio.DBusCallFlags.NONE,
        1500,
        None,
    ).unpack()


def snapshot(bus, preferred=None):
    names = sorted(
        name
        for name in call(
            bus, "org.freedesktop.DBus", "org.freedesktop.DBus", "ListNames"
        )[0]
        if name.startswith(PREFIX)
    )
    if not names:
        return names, None, {}
    name = preferred if preferred in names else names[0]
    properties = call(
        bus,
        name,
        "org.freedesktop.DBus.Properties",
        "GetAll",
        GLib.Variant("(s)", (PLAYER,)),
    )[0]
    return names, name, properties


def artwork(url):
    """Read small local or HTTP album artwork; failures leave the record icon."""
    parsed = urlparse(url)
    if parsed.scheme == "file" and parsed.netloc in ("", "localhost"):
        stream = open(unquote(parsed.path), "rb")
    elif parsed.scheme in ("http", "https"):
        stream = urlopen(url, timeout=3)
    else:
        return None
    with stream:
        data = stream.read(4 * 1024 * 1024 + 1)
    return data if len(data) <= 4 * 1024 * 1024 else None


def duration(microseconds):
    seconds = max(0, int(microseconds or 0) // 1_000_000)
    minutes, seconds = divmod(seconds, 60)
    hours, minutes = divmod(minutes, 60)
    return (
        f"{hours}:{minutes:02d}:{seconds:02d}" if hours else f"{minutes}:{seconds:02d}"
    )


class RetroMedia(Widget):
    def __init__(self):
        super().__init__("Media", "MEDIA / STEREO DECK")
        self.names = []
        self.player = None
        self.busy = False
        self.updating = False
        self.art_url = None

    def build(self, body):
        body.add_css_class("media-deck")
        body.set_spacing(12)
        self.selector = Gtk.DropDown(model=Gtk.StringList.new([]))
        self.selector.set_tooltip_text("Choose a running media player")
        self.selector.connect("notify::selected", self.choose_player)
        body.append(self.selector)

        record = Gtk.Box(spacing=14)
        record.add_css_class("media-record")
        self.cover = Gtk.Stack()
        self.cover.set_size_request(76, 76)
        fallback = Gtk.Label(label="◎")
        fallback.add_css_class("record-icon")
        self.cover.add_named(fallback, "record")
        self.picture = Gtk.Picture()
        self.picture.set_content_fit(Gtk.ContentFit.CONTAIN)
        self.picture.set_size_request(76, 76)
        self.cover.add_named(self.picture, "art")
        record.append(self.cover)
        info = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=5, hexpand=True)
        info.set_valign(Gtk.Align.CENTER)
        self.title = self.label(info, "No player connected", "track-title")
        self.artist = self.label(info, "Open a music player", "track-artist")
        self.album = self.label(info, "", "panel-footer")
        for label in (self.title, self.artist, self.album):
            label.set_xalign(0)
            label.set_ellipsize(Pango.EllipsizeMode.END)
            label.set_max_width_chars(22)
        record.append(info)
        body.append(record)

        self.progress = Gtk.ProgressBar()
        body.append(self.progress)
        timeline = Gtk.Box()
        self.elapsed = self.label(timeline, "0:00", "clock-zone")
        self.elapsed.set_hexpand(True)
        self.elapsed.set_xalign(0)
        self.length = self.label(timeline, "--:--", "clock-zone")
        body.append(timeline)
        controls = Gtk.Box(spacing=8, homogeneous=True)
        self.previous = self.button(
            "|<<", "Previous track", lambda _: self.control("Previous")
        )
        self.play = self.button(
            "PLAY", "Play or pause", lambda _: self.control("PlayPause")
        )
        self.play.add_css_class("transport-play")
        self.next = self.button(">>|", "Next track", lambda _: self.control("Next"))
        for button in (self.previous, self.play, self.next):
            button.set_sensitive(False)
            controls.append(button)
        body.append(controls)
        self.status = self.label(body, "WAITING / MPRIS", "panel-footer")
        self.status.set_xalign(0)
        self.poll()
        self.every(1, self.poll)

    def choose_player(self, selector, _property):
        if self.updating:
            return
        index = selector.get_selected()
        self.player = self.names[index] if index < len(self.names) else None
        self.poll()

    def poll(self):
        if not self.busy and not self.closed:
            self.busy = True
            threading.Thread(
                target=self.fetch, args=(self.player,), daemon=True
            ).start()
        return GLib.SOURCE_CONTINUE

    def fetch(self, preferred):
        try:
            bus = Gio.bus_get_sync(Gio.BusType.SESSION, None)
            result = snapshot(bus, preferred)
            url = result[2].get("Metadata", {}).get("mpris:artUrl", "")
            data = None
            if url and url != self.art_url:
                try:
                    data = artwork(url)
                except (OSError, ValueError):
                    pass
            GLib.idle_add(self.apply, preferred, result, url, data, None)
        except Exception as error:
            GLib.idle_add(self.apply, preferred, ([], None, {}), "", None, str(error))

    def apply(self, preferred, result, url, data, error):
        self.busy = False
        if self.closed:
            return GLib.SOURCE_REMOVE
        # A selector change can race an in-flight metadata/artwork request.
        if preferred != self.player:
            self.poll()
            return GLib.SOURCE_REMOVE
        names, name, props = result
        self.updating = True
        if names != self.names:
            self.selector.set_model(
                Gtk.StringList.new([n[len(PREFIX) :] for n in names])
            )
            self.names = names
        self.selector.set_sensitive(bool(names))
        if name:
            self.selector.set_selected(names.index(name))
        self.player = name
        self.updating = False
        metadata = props.get("Metadata", {})
        for label, text in (
            (
                self.title,
                metadata.get("xesam:title")
                or ("Unknown track" if name else "No player connected"),
            ),
            (
                self.artist,
                ", ".join(metadata.get("xesam:artist", []))
                or ("Unknown artist" if name else "Open a music player"),
            ),
            (self.album, metadata.get("xesam:album", "")),
        ):
            label.set_text(text)
            label.set_tooltip_text(text)
        playing = props.get("PlaybackStatus") == "Playing"
        self.play.set_label("PAUSE" if playing else "PLAY")
        can_control = props.get("CanControl", False)
        self.play.set_sensitive(
            can_control and props.get("CanPause" if playing else "CanPlay", False)
        )
        self.previous.set_sensitive(can_control and props.get("CanGoPrevious", False))
        self.next.set_sensitive(can_control and props.get("CanGoNext", False))
        position = max(0, props.get("Position", 0))
        length = metadata.get("mpris:length", 0)
        self.progress.set_fraction(min(1, position / length) if length > 0 else 0)
        self.elapsed.set_text(duration(position))
        self.length.set_text(duration(length) if length > 0 else "--:--")
        self.status.set_text(
            "PLAYER UNAVAILABLE / RETRYING"
            if error
            else f"{props.get('PlaybackStatus', 'WAITING').upper()} / MPRIS"
        )
        self.status.set_tooltip_text(error)
        if url != self.art_url:
            self.art_url = url
            self.cover.set_visible_child_name("record")
            self.picture.set_paintable(None)
            if data:
                try:
                    texture = Gdk.Texture.new_from_bytes(GLib.Bytes.new(data))
                    self.picture.set_paintable(texture)
                    self.cover.set_visible_child_name("art")
                except GLib.Error:
                    pass
        return GLib.SOURCE_REMOVE

    def control(self, method):
        if self.player:
            threading.Thread(
                target=self.send_control, args=(self.player, method), daemon=True
            ).start()

    def send_control(self, name, method):
        try:
            bus = Gio.bus_get_sync(Gio.BusType.SESSION, None)
            call(bus, name, PLAYER, method)
            GLib.idle_add(self.refresh)
        except GLib.Error as error:
            GLib.idle_add(self.control_error, str(error))

    def refresh(self):
        self.poll()
        return GLib.SOURCE_REMOVE

    def control_error(self, error):
        if not self.closed:
            self.status.set_text("CONTROL UNAVAILABLE")
            self.status.set_tooltip_text(error)
        return GLib.SOURCE_REMOVE


if __name__ == "__main__":
    raise SystemExit(RetroMedia().run())
