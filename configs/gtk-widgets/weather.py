#!/usr/bin/env python3
"""City-based current weather from Open-Meteo, fetched off the GTK thread."""

import argparse
import json
import threading
from datetime import datetime
from urllib.parse import urlencode
from urllib.request import urlopen

from widget import GLib, Gtk, Widget


def get_json(url, params):
    with urlopen(f"{url}?{urlencode(params)}", timeout=15) as response:
        return json.load(response)


def conditions(code):
    if code == 0:
        return "Clear sky"
    if code in (1, 2, 3):
        return {1: "Mostly clear", 2: "Partly cloudy", 3: "Overcast"}[code]
    if code in (45, 48):
        return "Fog"
    if code in (51, 53, 55, 56, 57):
        return "Drizzle"
    if code in (61, 63, 65, 66, 67, 80, 81, 82):
        return "Rain"
    if code in (71, 73, 75, 77, 85, 86):
        return "Snow"
    if code in (95, 96, 99):
        return "Thunderstorm"
    return "Unknown conditions"


def weather_art(code):
    """Small ASCII illustrations that work with terminal fonts."""
    if code in (0, 1):
        return "   \\ | /   \n  -- O --  \n   / | \\   "
    if code in (45, 48):
        return "  ~~~~~~~  \n ~~~~~~~~~ \n  ~~~~~~~  "
    cloud = "   .--.    \n .(    ).  \n(___..___) "
    if code in (71, 73, 75, 77, 85, 86):
        return cloud + "\n *  *  *  "
    if code in (95, 96, 99):
        return cloud + "\n   /_ /   "
    if code in (51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82):
        return cloud + "\n / / / /  "
    return cloud


def fetch_weather(city, fahrenheit=False):
    result = get_json(
        "https://geocoding-api.open-meteo.com/v1/search",
        {
            "name": city,
            "count": 1,
            "language": "en",
            "format": "json",
        },
    )
    if not result.get("results"):
        raise ValueError("City not found. Try a nearby city.")
    place = result["results"][0]
    data = get_json(
        "https://api.open-meteo.com/v1/forecast",
        {
            "latitude": place["latitude"],
            "longitude": place["longitude"],
            "current": "temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,wind_speed_10m",
            "temperature_unit": "fahrenheit" if fahrenheit else "celsius",
            "wind_speed_unit": "mph" if fahrenheit else "kmh",
            "timezone": "auto",
        },
    )
    location = ", ".join(
        dict.fromkeys(
            str(place[key]) for key in ("name", "admin1", "country") if place.get(key)
        )
    )
    current = data["current"]
    # Validate fields before handing the result to the GTK thread.
    for key in (
        "temperature_2m",
        "apparent_temperature",
        "relative_humidity_2m",
        "wind_speed_10m",
        "weather_code",
    ):
        if not isinstance(current.get(key), (int, float)):
            raise ValueError("Weather data is incomplete. Try refreshing.")
    return location, current


class RetroWeather(Widget):
    def __init__(self, city="", fahrenheit=False):
        super().__init__("Weather", "WX / FIELD REPORT")
        self.city = city
        self.fahrenheit = fahrenheit
        self.busy = False

    def build(self, body):
        body.add_css_class("instrument")
        body.set_spacing(12)
        place = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=3)
        self.location = self.label(place, self.city.upper() or "NO STATION", "place")
        self.location.set_xalign(0)
        self.location.set_wrap(True)
        self.location.set_max_width_chars(24)
        self.region = self.label(place, "CURRENT CONDITIONS", "region")
        self.region.set_xalign(0)
        self.region.set_wrap(True)
        self.region.set_max_width_chars(42)
        body.append(place)

        hero = Gtk.Box(spacing=12)
        reading = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0, hexpand=True)
        self.temperature = self.label(reading, "--°", "readout")
        self.temperature.set_xalign(0)
        self.description = self.label(reading, "AWAITING DATA", "condition")
        self.description.set_xalign(0)
        self.description.set_wrap(True)
        self.description.set_max_width_chars(22)
        hero.append(reading)
        self.art = Gtk.Label(label="   [ ? ]   ", valign=Gtk.Align.CENTER)
        self.art.add_css_class("weather-art")
        hero.append(self.art)
        body.append(hero)
        body.append(Gtk.Separator())

        stats = Gtk.Box(homogeneous=True)
        self.values = {}
        for key, title in (
            ("feels", "FEELS LIKE"),
            ("humidity", "HUMIDITY"),
            ("wind", "WIND"),
        ):
            cell = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
            cell.add_css_class("stat-cell")
            self.label(cell, title, "eyebrow")
            self.values[key] = self.label(cell, "--", "stat-value")
            stats.append(cell)
        body.append(stats)

        row = Gtk.Box(spacing=8)
        row.add_css_class("console-row")
        prompt = Gtk.Label(label=">")
        prompt.add_css_class("eyebrow")
        row.append(prompt)
        self.entry = Gtk.Entry(
            placeholder_text="Enter a city", text=self.city, hexpand=True
        )
        self.entry.set_width_chars(15)
        self.entry.connect("activate", self.search)
        row.append(self.entry)
        self.refresh_button = self.button(
            "[FETCH]", "Fetch weather for this city", self.search
        )
        row.append(self.refresh_button)
        body.append(row)
        self.status = self.label(body, "ENTER CITY / PRESS ENTER", "panel-footer")
        self.status.set_xalign(0)
        self.status.set_wrap(True)
        self.status.set_max_width_chars(42)
        if self.city:
            self.search()
        self.every(600, self.auto_refresh)

    def search(self, _widget=None):
        city = self.entry.get_text().strip()
        if self.busy:
            return
        if not city:
            self.status.set_text("Enter a city first.")
            return
        self.city = city
        self.busy = True
        self.entry.set_sensitive(False)
        self.refresh_button.set_sensitive(False)
        self.location.set_text(city.upper())
        self.region.set_text("RESOLVING STATION")
        self.temperature.set_text("--°")
        self.art.set_text("   [ … ]   ")
        self.description.set_text("FETCHING DATA")
        for value in self.values.values():
            value.set_text("--")
        self.status.remove_css_class("error")
        self.status.set_text("CONNECTING / OPEN-METEO")
        threading.Thread(target=self.worker, args=(city,), daemon=True).start()

    def worker(self, city):
        try:
            result, error = fetch_weather(city, self.fahrenheit), None
        except ValueError as exc:
            result, error = None, str(exc)
        except Exception:
            result, error = (
                None,
                "Weather unavailable. Check your connection and retry.",
            )
        GLib.idle_add(self.finish, result, error)

    def finish(self, result, error):
        if self.closed:
            return GLib.SOURCE_REMOVE
        self.busy = False
        self.entry.set_sensitive(True)
        self.refresh_button.set_sensitive(True)
        if error:
            self.description.set_text("NO SIGNAL")
            self.region.set_text("STATION UNAVAILABLE")
            self.art.set_text("   [ ! ]   ")
            self.status.add_css_class("error")
            self.status.set_text(error)
            return GLib.SOURCE_REMOVE
        location, current = result
        unit, wind_unit = ("°F", "mph") if self.fahrenheit else ("°C", "km/h")
        city, _, region = location.partition(", ")
        self.location.set_text(city.upper())
        self.region.set_text(region.upper())
        self.temperature.set_text(f"{current['temperature_2m']:.0f}{unit}")
        self.description.set_text(conditions(current["weather_code"]).upper())
        self.art.set_text(weather_art(current["weather_code"]))
        self.values["feels"].set_text(f"{current['apparent_temperature']:.0f}{unit}")
        self.values["humidity"].set_text(f"{current['relative_humidity_2m']:.0f}%")
        self.values["wind"].set_text(f"{current['wind_speed_10m']:.0f}")
        self.values["wind"].set_tooltip_text(wind_unit)
        self.status.remove_css_class("error")
        self.status.set_text(
            f"SYNC {datetime.now():%H:%M} / WIND {wind_unit.upper()} / AUTO 10m"
        )
        return GLib.SOURCE_REMOVE

    def auto_refresh(self):
        if self.city:
            self.search()
        return GLib.SOURCE_CONTINUE


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--city", default="", help="Initial city, e.g. 'Manchester'")
    parser.add_argument("--fahrenheit", action="store_true", help="Use °F and mph")
    args = parser.parse_args()
    raise SystemExit(RetroWeather(args.city, args.fahrenheit).run([]))
