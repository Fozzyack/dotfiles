"""Shared window styling and lifecycle for the retro widgets."""

from ctypes import CDLL
from pathlib import Path

# Layer Shell must be loaded before GTK links libwayland-client.
CDLL("libgtk4-layer-shell.so")

import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Gdk", "4.0")
gi.require_version("Gtk4LayerShell", "1.0")
from gi.repository import Gdk, GLib, Gtk, Gtk4LayerShell


# Edge-anchored columns: (horizontal edge, inset, distance from top).
POSITIONS = {
    "Clock": (Gtk4LayerShell.Edge.LEFT, 30, 80),
    "Calendar": (Gtk4LayerShell.Edge.LEFT, 30, 300),
    "Weather": (Gtk4LayerShell.Edge.RIGHT, 30, 80),
    "System": (Gtk4LayerShell.Edge.RIGHT, 30, 580),
}


class Widget(Gtk.Application):
    def __init__(self, name, heading):
        super().__init__(application_id=f"com.example.Retro{name}")
        self.name = name
        self.heading = heading
        self.timers = []
        self.closed = False

    def do_activate(self):
        if self.get_active_window():
            self.get_active_window().present()
            return
        provider = Gtk.CssProvider()
        provider.load_from_path(str(Path(__file__).with_name("clock.css")))
        Gtk.StyleContext.add_provider_for_display(
            Gdk.Display.get_default(),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION,
        )
        window = Gtk.ApplicationWindow(application=self, title=f"Retro {self.name}")
        Gtk4LayerShell.init_for_window(window)
        # Above wallpaper, below every normal window; no desktop space reserved.
        Gtk4LayerShell.set_layer(window, Gtk4LayerShell.Layer.BOTTOM)
        Gtk4LayerShell.set_namespace(window, f"retro-{self.name.lower()}")
        Gtk4LayerShell.set_keyboard_mode(window, Gtk4LayerShell.KeyboardMode.ON_DEMAND)
        Gtk4LayerShell.set_exclusive_zone(window, -1)
        edge, inset, top = POSITIONS[self.name]
        Gtk4LayerShell.set_anchor(window, edge, True)
        Gtk4LayerShell.set_anchor(window, Gtk4LayerShell.Edge.TOP, True)
        Gtk4LayerShell.set_margin(window, edge, inset)
        Gtk4LayerShell.set_margin(window, Gtk4LayerShell.Edge.TOP, top)
        window.add_css_class("retro-clock")
        window.set_decorated(False)
        window.set_resizable(False)
        window.set_default_size(400 if self.name in ("Weather", "System") else 360, -1)
        body = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=16)
        body.add_css_class("body")
        body.set_size_request(310, -1)
        window.set_child(body)
        top = Gtk.Box(spacing=12)
        tag = Gtk.Label(label=f"> {self.heading}", xalign=0, hexpand=True)
        tag.add_css_class("muted")
        top.append(tag)
        top.append(self.button("[x]", "Close widget", lambda _: window.close()))
        body.append(top)
        self.build(body)
        keys = Gtk.EventControllerKey()
        keys.connect("key-pressed", self.on_key)
        window.add_controller(keys)
        window.present()

    @staticmethod
    def button(text, tooltip, callback):
        button = Gtk.Button(label=text, tooltip_text=tooltip)
        button.connect("clicked", callback)
        return button

    @staticmethod
    def label(body, text="", style=None):
        label = Gtk.Label(label=text)
        if style:
            label.add_css_class(style)
        body.append(label)
        return label

    def every(self, seconds, callback):
        self.timers.append(GLib.timeout_add_seconds(seconds, callback))

    def on_key(self, _controller, key, _code, _state):
        if key == Gdk.KEY_Escape:
            self.get_active_window().close()
            return True
        return False

    def do_shutdown(self):
        self.closed = True
        for timer in self.timers:
            GLib.source_remove(timer)
        self.timers.clear()
        Gtk.Application.do_shutdown(self)
