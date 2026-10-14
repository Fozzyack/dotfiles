#!/usr/bin/env python3
"""Linux CPU, RAM and system load without third-party monitoring packages."""

import os
import socket
from collections import deque
from pathlib import Path

from widget import GLib, Gtk, Widget


def read_cpu():
    # Guest times are already included in user/nice: exclude them from totals.
    values = [
        int(value)
        for value in Path("/proc/stat").read_text().splitlines()[0].split()[1:9]
    ]
    return sum(values), values[3] + values[4]


def cpu_fraction(previous, current):
    total = current[0] - previous[0]
    idle = current[1] - previous[1]
    return max(0.0, min(1.0, (total - idle) / total)) if total > 0 else 0.0


def read_memory():
    values = {}
    for line in Path("/proc/meminfo").read_text().splitlines():
        key, value = line.split(":", 1)
        values[key] = int(value.split()[0])
    total = values["MemTotal"]
    return total - values["MemAvailable"], total


class SegmentMeter(Gtk.Box):
    """A discrete terminal-style utilization meter."""

    def __init__(self, style=None):
        super().__init__(spacing=3, homogeneous=True)
        if style:
            self.add_css_class(style)
        self.segments = []
        for _ in range(24):
            segment = Gtk.Box()
            segment.add_css_class("segment")
            self.append(segment)
            self.segments.append(segment)

    def set_fraction(self, fraction):
        fraction = max(0, min(1, fraction))
        count = round(fraction * len(self.segments))
        for index, segment in enumerate(self.segments):
            if index < count:
                segment.add_css_class("active")
            else:
                segment.remove_css_class("active")
        self.set_tooltip_text(f"{fraction:.1%}")


class RetroSystem(Widget):
    def __init__(self):
        super().__init__("System", "SYS / RESOURCE MONITOR")
        self.previous_cpu = None
        self.history = deque(maxlen=30)

    def build(self, body):
        body.add_css_class("instrument")
        body.set_spacing(12)
        host = self.label(body, socket.gethostname().upper(), "place")
        host.set_xalign(0)
        host.set_wrap(True)
        host.set_max_width_chars(26)
        self.label(
            body, f"LINUX / {os.cpu_count() or 1:02d} LOGICAL CPUS", "eyebrow"
        ).set_xalign(0)
        body.append(Gtk.Separator())
        self.cpu_label, self.cpu_bar, self.cpu_detail = self.resource(
            body, "01 / PROCESSOR"
        )
        self.ram_label, self.ram_bar, self.ram_detail = self.resource(
            body, "02 / MEMORY", "ram-meter"
        )
        self.ram_label.add_css_class("ram-value")

        history = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self.label(history, "CPU TRACE / LAST 60s", "eyebrow").set_xalign(0)
        self.trace = self.label(history, "·" * 30, "history")
        self.trace.set_xalign(0)
        history.set_tooltip_text("One CPU utilization sample every 2 seconds; 0–100%")
        body.append(history)
        body.append(Gtk.Separator())
        loads = Gtk.Box(homogeneous=True)
        self.load_values = []
        for period in ("01 MIN", "05 MIN", "15 MIN"):
            cell = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4)
            cell.add_css_class("stat-cell")
            self.label(cell, period, "eyebrow")
            self.load_values.append(self.label(cell, "--", "stat-value"))
            loads.append(cell)
        loads.set_tooltip_text(
            "System load averages: runnable and uninterruptible tasks, not percentages"
        )
        body.append(loads)
        self.status = self.label(body, "SAMPLING / INTERVAL 2s", "panel-footer")
        self.status.set_xalign(0)
        self.tick()
        self.every(2, self.tick)

    def resource(self, body, title, style=None):
        section = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=5)
        row = Gtk.Box(spacing=8)
        self.label(row, title, "eyebrow").set_hexpand(True)
        value = self.label(row, "--%", "meter-value")
        section.append(row)
        meter = SegmentMeter(style)
        section.append(meter)
        detail = self.label(section, "SAMPLING…", "region")
        detail.set_xalign(0)
        body.append(section)
        return value, meter, detail

    def tick(self):
        try:
            current = read_cpu()
            if self.previous_cpu is not None:
                usage = cpu_fraction(self.previous_cpu, current)
                self.cpu_label.set_text(f"{usage:.0%}")
                self.cpu_bar.set_fraction(usage)
                self.history.append(usage)
                bars = "▁▂▃▄▅▆▇█"
                self.trace.set_text(
                    "·" * (30 - len(self.history))
                    + "".join(bars[min(7, int(value * 8))] for value in self.history)
                )
                self.cpu_detail.set_text(f"{usage:.1%} BUSY / {1 - usage:.1%} IDLE")
            self.previous_cpu = current
            used, total = read_memory()
            self.ram_label.set_text(f"{used / total:.0%}")
            self.ram_detail.set_text(
                f"{used / 1048576:.1f} GiB USED / {total / 1048576:.1f} GiB TOTAL"
            )
            self.ram_bar.set_fraction(used / total)
            for label, load in zip(self.load_values, os.getloadavg()):
                label.set_text(f"{load:.2f}")
            self.status.remove_css_class("error")
            self.status.set_text("LIVE / LOAD AVG ABOVE / INTERVAL 2s")
        except (OSError, ValueError, KeyError, IndexError, ZeroDivisionError):
            self.status.add_css_class("error")
            self.status.set_text("System metrics unavailable · retrying…")
        return GLib.SOURCE_CONTINUE


if __name__ == "__main__":
    raise SystemExit(RetroSystem().run())
