#!/usr/bin/env python3
"""Local Linux network traffic monitor; no external services or probes."""

from collections import deque
from pathlib import Path
import time

from widget import GLib, Gtk, Widget


def read_counters():
    counters = {}
    for line in Path("/proc/net/dev").read_text().splitlines()[2:]:
        interface, values = line.rsplit(":", 1)
        fields = values.split()
        interface = interface.strip()
        if interface != "lo":
            counters[interface] = (int(fields[0]), int(fields[8]))
    return counters


def automatic_interface(counters):
    """Prefer the lowest-metric IPv4 default route, then a busy interface."""
    routes = []
    try:
        for line in Path("/proc/net/route").read_text().splitlines()[1:]:
            fields = line.split()
            if (
                fields[0] in counters
                and fields[1] == "00000000"
                and fields[7] == "00000000"
                and int(fields[3], 16) & 1
            ):
                routes.append((int(fields[6]), fields[0]))
    except (OSError, ValueError, IndexError):
        pass
    if routes:
        return min(routes)[1]
    return max(counters, key=lambda name: sum(counters[name]), default=None)


def rates(previous, current, elapsed):
    # Resets, reconnection, and invalid intervals must not produce traffic spikes.
    if (
        previous is None
        or elapsed <= 0
        or any(a < b for a, b in zip(current, previous))
    ):
        return None
    return tuple((a - b) / elapsed for a, b in zip(current, previous))


def format_bytes(value):
    value = max(0, value)
    for unit in ("B", "KiB", "MiB", "GiB", "TiB"):
        if value < 1024 or unit == "TiB":
            return f"{value:.1f} {unit}" if unit != "B" else f"{value:.0f} B"
        value /= 1024


def trace(samples):
    ceiling = max(1024, max(samples, default=0))
    glyphs = "▁▂▃▄▅▆▇█"
    graph = "·" * (30 - len(samples)) + "".join(
        glyphs[min(7, int(sample / ceiling * 7))] for sample in samples
    )
    return graph, ceiling


class RetroNetwork(Widget):
    def __init__(self):
        super().__init__("Network", "NETWORK / TRAFFIC")
        self.interfaces = []
        self.interface = None
        self.previous = None
        self.last_time = None
        self.histories = [deque(maxlen=30), deque(maxlen=30)]
        self.updating = False

    def build(self, body):
        body.add_css_class("network-panel")
        body.set_spacing(12)
        self.selector = Gtk.DropDown(model=Gtk.StringList.new(["AUTO / DEFAULT ROUTE"]))
        self.selector.set_tooltip_text(
            "Network interface to monitor; loopback excluded"
        )
        self.selector.connect("notify::selected", self.choose_interface)
        body.append(self.selector)
        self.values, self.graphs, self.scales = [], [], []
        for heading, style in (
            ("RX / DOWNLOAD", "network-rx"),
            ("TX / UPLOAD", "network-tx"),
        ):
            section = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=5)
            section.add_css_class("traffic-section")
            section.add_css_class(style)
            self.label(section, heading, "eyebrow").set_xalign(0)
            value = self.label(section, "-- /s", "traffic-rate")
            value.set_xalign(0)
            graph = self.label(section, "·" * 30, "traffic-trace")
            graph.set_tooltip_text(
                "Last 30 samples, oldest to newest; independently auto-scaled"
            )
            scale = self.label(section, "30 SAMPLES / SAMPLING…", "clock-zone")
            scale.set_xalign(0)
            self.values.append(value)
            self.graphs.append(graph)
            self.scales.append(scale)
            body.append(section)
        self.totals = self.label(body, "", "panel-footer")
        self.totals.set_xalign(0)
        self.totals.set_tooltip_text(
            "Interface byte counters since creation or reset, not internet usage or session totals"
        )
        self.status = self.label(body, "SAMPLING…", "panel-footer")
        self.status.set_xalign(0)
        self.tick()
        self.every(1, self.tick)

    def choose_interface(self, _selector, _property):
        if not self.updating:
            self.reset()
            self.tick()

    def reset(self):
        self.previous = self.last_time = None
        for index, history in enumerate(self.histories):
            history.clear()
            self.values[index].set_text("-- /s")
            self.graphs[index].set_text("·" * 30)
            self.scales[index].set_text("30 SAMPLES / SAMPLING…")

    def tick(self):
        try:
            counters = read_counters()
            interfaces = sorted(counters)
            selected = self.selector.get_selected()
            preferred = (
                self.interfaces[selected - 1]
                if 0 < selected <= len(self.interfaces)
                else None
            )
            if interfaces != self.interfaces:
                self.updating = True
                self.interfaces = interfaces
                self.selector.set_model(
                    Gtk.StringList.new(["AUTO / DEFAULT ROUTE", *interfaces])
                )
                self.selector.set_selected(
                    interfaces.index(preferred) + 1 if preferred in interfaces else 0
                )
                self.updating = False
            interface = (
                preferred if preferred in counters else automatic_interface(counters)
            )
            if interface != self.interface:
                self.reset()
                self.interface = interface
            if interface is None:
                self.reset()
                self.totals.set_text("")
                self.status.remove_css_class("error")
                self.status.set_text("NO NETWORK INTERFACE / RETRYING")
                return GLib.SOURCE_CONTINUE
            current = counters[interface]
            now = time.monotonic()
            speed = rates(
                self.previous,
                current,
                now - self.last_time if self.last_time is not None else 0,
            )
            if speed is None:
                self.reset()
            else:
                for index, value in enumerate(speed):
                    self.histories[index].append(value)
                    graph, ceiling = trace(self.histories[index])
                    self.values[index].set_text(f"{format_bytes(value)}/s")
                    self.graphs[index].set_text(graph)
                    self.scales[index].set_text(
                        f"30 SAMPLES / PEAK SCALE {format_bytes(ceiling)}/s"
                    )
            self.previous, self.last_time = current, now
            self.totals.set_text(
                f"TOTAL RX {format_bytes(current[0])} / TX {format_bytes(current[1])}"
            )
            self.status.remove_css_class("error")
            self.status.set_text(
                f"{interface} / {'LIVE' if speed is not None else 'SAMPLING'} / 1s"
            )
        except (OSError, ValueError, IndexError):
            self.reset()
            self.totals.set_text("")
            self.status.add_css_class("error")
            self.status.set_text("COUNTERS UNAVAILABLE / RETRYING")
        return GLib.SOURCE_CONTINUE


if __name__ == "__main__":
    raise SystemExit(RetroNetwork().run())
