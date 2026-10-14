#!/usr/bin/env python3
"""Compact configurable focus timer with monotonic pause/resume accounting."""

import json
import math
import os
from pathlib import Path
import time

from widget import GLib, Gtk, Widget
from gi.repository import Gio

DEFAULTS = {"focus": 25, "short_break": 5, "long_break": 15}
LABELS = {"focus": "FOCUS", "short_break": "SHORT BREAK", "long_break": "LONG BREAK"}


def load_settings(path):
    try:
        data = json.loads(path.read_text())
        if not isinstance(data, dict):
            return DEFAULTS.copy()
        return {
            key: data[key]
            if type(data.get(key)) is int and 1 <= data[key] <= 180
            else default
            for key, default in DEFAULTS.items()
        }
    except (OSError, ValueError):
        return DEFAULTS.copy()


class Countdown:
    def __init__(self, settings):
        self.settings = dict(settings)
        self.reset()

    def reset(self):
        self.phase = "focus"
        self.completed = 0
        self.deadline = None
        self.remaining = self.duration

    @property
    def duration(self):
        return self.settings[self.phase] * 60

    def toggle(self, now):
        # A click arriving just after expiry should not silently start a break.
        finished = self.update(now)
        if finished:
            return finished
        if self.deadline is None:
            self.deadline = now + self.remaining
        else:
            self.deadline = None
        return None

    def update(self, now):
        if self.deadline is None:
            return None
        self.remaining = max(0, self.deadline - now)
        if self.remaining > 0:
            return None
        finished = self.phase
        if finished == "focus":
            self.completed += 1
            self.phase = "long_break" if self.completed % 4 == 0 else "short_break"
        else:
            self.phase = "focus"
        # Wait for an explicit start; unattended timers don't accumulate sessions.
        self.deadline = None
        self.remaining = self.duration
        return finished


class RetroPomodoro(Widget):
    def __init__(self):
        super().__init__("Pomodoro", "FOCUS / POMODORO")
        config = Path(os.environ.get("XDG_CONFIG_HOME", str(Path.home() / ".config")))
        self.settings_path = config / "retro-widgets" / "pomodoro.json"
        self.timer = Countdown(load_settings(self.settings_path))

    def build(self, body):
        body.add_css_class("pomodoro-panel")
        body.set_spacing(10)
        self.phase_label = self.label(body, style="eyebrow")
        self.readout = self.label(body, style="pomodoro-time")
        self.progress = Gtk.ProgressBar()
        body.append(self.progress)
        self.status = self.label(body, style="panel-footer")
        controls = Gtk.Box(spacing=8, homogeneous=True)
        self.start = self.button(
            "START", "Start or pause the current interval", self.toggle
        )
        controls.append(self.start)
        controls.append(
            self.button(
                "RESET", "Reset to focus and clear the session count", self.reset
            )
        )
        body.append(controls)

        settings = Gtk.Expander(label="DURATIONS / MINUTES")
        fields = Gtk.Grid(column_spacing=8, row_spacing=6)
        fields.add_css_class("pomodoro-settings")
        self.inputs = {}
        for row, (key, title) in enumerate(LABELS.items()):
            fields.attach(Gtk.Label(label=title, xalign=0, hexpand=True), 0, row, 1, 1)
            spin = Gtk.SpinButton.new_with_range(1, 180, 1)
            spin.set_value(self.timer.settings[key])
            spin.set_numeric(True)
            fields.attach(spin, 1, row, 1, 1)
            self.inputs[key] = spin
        fields.attach(
            self.button(
                "SAVE & RESET", "Save durations and reset the timer", self.save
            ),
            0,
            3,
            2,
            1,
        )
        self.save_status = Gtk.Label(
            label="Long break after every 4 focus sessions", wrap=True
        )
        self.save_status.add_css_class("clock-zone")
        fields.attach(self.save_status, 0, 4, 2, 1)
        settings.set_child(fields)
        body.append(settings)
        self.render()
        self.every(1, self.tick)

    def notify_finished(self, phase):
        notice = Gio.Notification.new(f"{LABELS[phase].title()} complete")
        notice.set_body(
            f"Ready for {LABELS[self.timer.phase].lower()}. Press START when ready."
        )
        self.send_notification("pomodoro", notice)

    def toggle(self, _button):
        finished = self.timer.toggle(time.monotonic())
        if finished:
            self.notify_finished(finished)
        self.render()

    def reset(self, _button):
        self.timer.reset()
        self.render()

    def save(self, _button):
        for spin in self.inputs.values():
            spin.update()
        settings = {key: spin.get_value_as_int() for key, spin in self.inputs.items()}
        try:
            self.settings_path.parent.mkdir(parents=True, exist_ok=True)
            temporary = self.settings_path.with_suffix(".tmp")
            temporary.write_text(json.dumps(settings, indent=2) + "\n")
            temporary.replace(self.settings_path)
        except OSError:
            self.save_status.set_text("Could not save settings; timer unchanged")
            return
        self.timer = Countdown(settings)
        self.save_status.set_text("Saved / timer reset")
        self.render()

    def render(self):
        minutes, seconds = divmod(math.ceil(self.timer.remaining), 60)
        self.readout.set_text(f"{minutes:02d}:{seconds:02d}")
        self.phase_label.set_text(LABELS[self.timer.phase])
        self.progress.set_fraction(1 - self.timer.remaining / self.timer.duration)
        running = self.timer.deadline is not None
        self.start.set_label("PAUSE" if running else "START")
        self.status.set_text(
            f"{'RUNNING' if running else 'READY / PAUSED'} · {self.timer.completed} COMPLETE"
        )
        if self.timer.phase == "focus":
            self.readout.remove_css_class("break-time")
        else:
            self.readout.add_css_class("break-time")

    def tick(self):
        finished = self.timer.update(time.monotonic())
        if finished:
            self.notify_finished(finished)
        self.render()
        return GLib.SOURCE_CONTINUE


if __name__ == "__main__":
    raise SystemExit(RetroPomodoro().run())
