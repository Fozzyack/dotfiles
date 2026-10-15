#!/usr/bin/env python3
"""Standalone retro-dark calendar."""

import calendar
from datetime import datetime
from widget import GLib, Gtk, Widget


class RetroCalendar(Widget):
    def __init__(self):
        super().__init__("Calendar", "DATEBOOK / LOCAL")
        self.today = datetime.now().date()
        self.month = self.today.replace(day=1)
        self.selected = self.today

    def build(self, body):
        body.add_css_class("datebook")
        body.set_spacing(12)
        today_card = Gtk.Box(spacing=14)
        today_card.add_css_class("today-card")
        self.today_number = self.label(today_card, style="today-number")
        today_copy = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
        today_copy.set_valign(Gtk.Align.CENTER)
        self.label(today_copy, "TODAY", "eyebrow").set_xalign(0)
        self.today_weekday = self.label(today_copy, style="today-weekday")
        self.today_weekday.set_xalign(0)
        self.today_date = self.label(today_copy, style="clock-zone")
        self.today_date.set_xalign(0)
        today_card.append(today_copy)
        body.append(today_card)

        navigation = Gtk.Box(spacing=8)
        navigation.add_css_class("month-navigation")
        heading = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, hexpand=True)
        self.year_label = self.label(heading, style="eyebrow")
        self.year_label.set_xalign(0)
        self.month_label = self.label(heading, style="calendar-month")
        self.month_label.set_xalign(0)
        navigation.append(heading)
        self.previous = self.button(
            "‹", "Previous month", lambda _: self.change_month(-1)
        )
        navigation.append(self.previous)
        self.next = self.button("›", "Next month", lambda _: self.change_month(1))
        navigation.append(self.next)
        body.append(navigation)

        self.grid = Gtk.Grid(
            column_homogeneous=True,
            row_homogeneous=True,
            column_spacing=4,
            row_spacing=4,
        )
        self.grid.add_css_class("calendar-grid")
        body.append(self.grid)
        detail = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4)
        detail.add_css_class("date-detail")
        self.selected_label = self.label(detail, style="selected-date")
        self.selected_label.set_xalign(0)
        self.detail_label = self.label(detail, style="panel-footer")
        self.detail_label.set_xalign(0)
        body.append(detail)
        footer = Gtk.Box(spacing=8)
        self.label(footer, "MON → SUN", "eyebrow").set_hexpand(True)
        footer.append(
            self.button(
                "[ TODAY ]", "Select today and return to its month", self.go_today
            )
        )
        body.append(footer)

        self.render_month()
        self.tick()
        self.every(1, self.tick)

    def change_month(self, delta):
        index = self.month.year * 12 + self.month.month - 1 + delta
        year, month = divmod(index, 12)
        if 1 <= year <= 9999:
            self.month = self.month.replace(year=year, month=month + 1)
            last = calendar.monthrange(year, month + 1)[1]
            self.selected = self.month.replace(day=min(self.selected.day, last))
            self.render_month()

    def go_today(self, _button):
        self.today = datetime.now().date()
        self.selected = self.today
        self.month = self.today.replace(day=1)
        self.render_month()

    def select_day(self, _button, day):
        self.selected = self.month.replace(day=day)
        # Keep the focused button alive when selecting with the keyboard.
        for number, button in self.day_buttons.items():
            if number == day:
                button.add_css_class("selected-day")
            else:
                button.remove_css_class("selected-day")
        self.render_detail()

    def render_detail(self):
        self.selected_label.set_text(self.selected.strftime("%A / %d %b %Y").upper())
        iso = self.selected.isocalendar()
        self.detail_label.set_text(
            f"WEEK {iso.week:02d} / {iso.year}   ·   DAY {self.selected:%j}"
        )

    def render_month(self):
        child = self.grid.get_first_child()
        while child:
            following = child.get_next_sibling()
            self.grid.remove(child)
            child = following

        self.today_number.set_text(f"{self.today.day:02d}")
        self.today_weekday.set_text(self.today.strftime("%A").upper())
        self.today_date.set_text(self.today.strftime("%d %B %Y").upper())
        self.month_label.set_text(self.month.strftime("%B").upper())
        self.year_label.set_text(f"{self.month.year:04d} / {self.month.month:02d}")
        self.previous.set_sensitive((self.month.year, self.month.month) != (1, 1))
        self.next.set_sensitive((self.month.year, self.month.month) != (9999, 12))
        self.day_buttons = {}
        for column, name in enumerate(("WK", "M", "T", "W", "T", "F", "S", "S")):
            label = Gtk.Label(label=name)
            label.add_css_class("weekday")
            self.grid.attach(label, column, 0, 1, 1)

        weeks = calendar.Calendar(firstweekday=0).monthdayscalendar(
            self.month.year, self.month.month
        )
        # Always show six rows so browsing doesn't resize the widget.
        weeks += [[0] * 7 for _ in range(6 - len(weeks))]
        for row, week in enumerate(weeks, start=1):
            first_day = next((day for day in week if day), None)
            week_label = Gtk.Label(
                label=(
                    f"{self.month.replace(day=first_day).isocalendar().week:02d}"
                    if first_day
                    else "·"
                )
            )
            week_label.add_css_class("week-number")
            self.grid.attach(week_label, 0, row, 1, 1)
            for column, day in enumerate(week):
                if not day:
                    blank = Gtk.Label(label="·")
                    blank.add_css_class("empty-day")
                    self.grid.attach(blank, column + 1, row, 1, 1)
                    continue
                date = self.month.replace(day=day)
                label = Gtk.Button(label=f"{day:02d}")
                label.add_css_class("calendar-day")
                label.set_tooltip_text(date.strftime("%A, %d %B %Y"))
                label.connect("clicked", self.select_day, day)
                self.day_buttons[day] = label
                if column >= 5:
                    label.add_css_class("weekend")
                if date == self.today:
                    label.add_css_class("today")
                if date == self.selected:
                    label.add_css_class("selected-day")
                self.grid.attach(label, column + 1, row, 1, 1)
        self.render_detail()

    def tick(self):
        now = datetime.now()
        if now.date() != self.today:
            # Follow midnight unless the user is browsing another month.
            following_today = self.month == self.today.replace(day=1)
            selected_today = self.selected == self.today
            self.today = now.date()
            if following_today:
                self.month = self.today.replace(day=1)
                if selected_today or self.selected.replace(day=1) != self.month:
                    self.selected = self.today
            self.render_month()
        return GLib.SOURCE_CONTINUE


if __name__ == "__main__":
    raise SystemExit(RetroCalendar().run())
