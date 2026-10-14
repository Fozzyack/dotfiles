#!/usr/bin/env python3
"""Standalone retro-dark calendar."""

import calendar
from datetime import datetime
from widget import GLib, Gtk, Widget


class RetroCalendar(Widget):
    def __init__(self):
        super().__init__("Calendar", "CALENDAR / MONDAY FIRST")
        self.today = datetime.now().date()
        self.month = self.today.replace(day=1)

    def build(self, body):
        navigation = Gtk.Box(spacing=8)
        self.previous = self.button(
            "‹", "Previous month", lambda _: self.change_month(-1)
        )
        navigation.append(self.previous)
        self.month_label = Gtk.Label(hexpand=True)
        self.month_label.add_css_class("month")
        navigation.append(self.month_label)
        self.next = self.button("›", "Next month", lambda _: self.change_month(1))
        navigation.append(self.next)
        body.append(navigation)

        self.grid = Gtk.Grid(
            column_homogeneous=True,
            row_homogeneous=True,
            column_spacing=4,
            row_spacing=4,
        )
        body.append(self.grid)
        body.append(self.button("Today", "Return to the current month", self.go_today))

        self.render_month()
        self.tick()
        self.every(1, self.tick)

    def change_month(self, delta):
        index = self.month.year * 12 + self.month.month - 1 + delta
        year, month = divmod(index, 12)
        if 1 <= year <= 9999:
            self.month = self.month.replace(year=year, month=month + 1)
            self.render_month()

    def go_today(self, _button):
        self.month = datetime.now().date().replace(day=1)
        self.render_month()

    def render_month(self):
        child = self.grid.get_first_child()
        while child:
            following = child.get_next_sibling()
            self.grid.remove(child)
            child = following

        self.month_label.set_text(self.month.strftime("%B %Y"))
        self.previous.set_sensitive((self.month.year, self.month.month) != (1, 1))
        self.next.set_sensitive((self.month.year, self.month.month) != (9999, 12))
        for column, name in enumerate(("Mo", "Tu", "We", "Th", "Fr", "Sa", "Su")):
            label = Gtk.Label(label=name)
            label.add_css_class("weekday")
            self.grid.attach(label, column, 0, 1, 1)

        weeks = calendar.Calendar(firstweekday=0).monthdayscalendar(
            self.month.year, self.month.month
        )
        # Always show six rows so browsing doesn't resize the widget.
        weeks += [[0] * 7 for _ in range(6 - len(weeks))]
        for row, week in enumerate(weeks, start=1):
            for column, day in enumerate(week):
                label = Gtk.Label(label=str(day) if day else "")
                label.add_css_class("day")
                if column >= 5:
                    label.add_css_class("weekend")
                if day and self.month.replace(day=day) == self.today:
                    label.add_css_class("today")
                    label.set_tooltip_text("Today")
                self.grid.attach(label, column, row, 1, 1)

    def tick(self):
        now = datetime.now()
        if now.date() != self.today:
            # Follow midnight unless the user is browsing another month.
            following_today = self.month == self.today.replace(day=1)
            self.today = now.date()
            if following_today:
                self.month = self.today.replace(day=1)
            self.render_month()
        return GLib.SOURCE_CONTINUE


if __name__ == "__main__":
    raise SystemExit(RetroCalendar().run())
