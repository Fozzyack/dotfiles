#!/usr/bin/env python3
"""Standalone 24-hour retro clock."""

from datetime import datetime

from widget import GLib, Widget


class RetroClock(Widget):
    def __init__(self):
        super().__init__("Clock", "LOCAL TIME / 24H")

    def build(self, body):
        self.time_label = self.label(body, style="clock")
        self.date_label = self.label(body, style="date")
        self.tick()
        self.every(1, self.tick)

    def tick(self):
        now = datetime.now()
        self.time_label.set_text(now.strftime("%H:%M:%S"))
        self.date_label.set_text(now.strftime("%A, %d %B %Y"))
        return GLib.SOURCE_CONTINUE


if __name__ == "__main__":
    raise SystemExit(RetroClock().run())
