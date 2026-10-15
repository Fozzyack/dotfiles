#!/usr/bin/env python3
"""Standalone 24-hour retro clock."""

from datetime import datetime

from widget import GLib, Gtk, Widget


class RetroClock(Widget):
    def __init__(self):
        super().__init__("Clock", "CHRONOMETER / 24H")

    def build(self, body):
        body.add_css_class("chronometer")
        body.set_spacing(8)
        display = Gtk.Box(spacing=12)
        display.add_css_class("clock-display")
        self.time_label = self.label(display, style="clock")
        self.time_label.set_xalign(0)
        self.time_label.set_hexpand(True)
        self.time_label.set_width_chars(5)
        seconds = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        seconds.set_valign(Gtk.Align.CENTER)
        seconds.add_css_class("seconds-panel")
        self.label(seconds, "SEC", "eyebrow")
        self.seconds_label = self.label(seconds, style="seconds")
        self.seconds_label.set_width_chars(2)
        display.append(seconds)
        body.append(display)
        self.date_label = self.label(body, style="date")
        self.date_label.set_xalign(0)

        footer = Gtk.Box(spacing=12)
        self.zone_label = self.label(footer, style="clock-zone")
        self.zone_label.set_xalign(0)
        self.zone_label.set_hexpand(True)
        self.progress_label = self.label(footer, style="clock-progress-label")
        body.append(footer)
        self.day_meter = Gtk.ProgressBar()
        self.day_meter.add_css_class("day-meter")
        body.append(self.day_meter)
        self.tick()
        self.every(1, self.tick)

    def tick(self):
        now = datetime.now().astimezone()
        self.time_label.set_text(now.strftime("%H:%M"))
        self.seconds_label.set_text(now.strftime("%S"))
        self.date_label.set_text(now.strftime("%a / %d %b %Y").upper())
        self.zone_label.set_text(f"LOCAL / {now.tzname()}")
        self.zone_label.set_tooltip_text(now.strftime("UTC offset: %z"))
        # Wall-clock position in the local day, including on DST change days.
        fraction = (now.hour * 3600 + now.minute * 60 + now.second) / 86400
        self.day_meter.set_fraction(fraction)
        self.progress_label.set_text(f"DAY {fraction:.0%}")
        self.day_meter.set_tooltip_text(f"Local day position: {now:%H:%M:%S}")
        return GLib.SOURCE_CONTINUE


if __name__ == "__main__":
    raise SystemExit(RetroClock().run())
