"""Data-handling checks; no display or live weather service required."""

import unittest
from unittest.mock import patch

from system_load import cpu_fraction, read_cpu, read_memory
from weather import fetch_weather


class SystemTests(unittest.TestCase):
    def test_cpu_excludes_guest_time_and_counts_iowait_as_idle(self):
        with patch(
            "system_load.Path.read_text",
            return_value="cpu 100 20 30 400 50 6 7 8 90 10\n",
        ):
            self.assertEqual(read_cpu(), (621, 450))

    def test_cpu_deltas_and_counter_reset(self):
        self.assertAlmostEqual(cpu_fraction((100, 50), (200, 75)), 0.75)
        self.assertEqual(cpu_fraction((100, 50), (100, 50)), 0)
        self.assertEqual(cpu_fraction((100, 50), (10, 5)), 0)

    def test_memory_uses_available_not_free(self):
        text = "MemTotal: 1000 kB\nMemFree: 100 kB\nMemAvailable: 600 kB\n"
        with patch("system_load.Path.read_text", return_value=text):
            self.assertEqual(read_memory(), (400, 1000))


class WeatherTests(unittest.TestCase):
    def test_location_and_imperial_request(self):
        place = {
            "results": [
                {
                    "name": "York",
                    "admin1": "England",
                    "country": "United Kingdom",
                    "latitude": 54,
                    "longitude": -1,
                }
            ]
        }
        current = {
            "temperature_2m": 50,
            "apparent_temperature": 48,
            "relative_humidity_2m": 80,
            "wind_speed_10m": 5,
            "weather_code": 3,
        }
        with patch(
            "weather.get_json", side_effect=[place, {"current": current}]
        ) as request:
            location, result = fetch_weather("York", fahrenheit=True)
        self.assertEqual(location, "York, England, United Kingdom")
        self.assertEqual(result, current)
        params = request.call_args.args[1]
        self.assertEqual(params["temperature_unit"], "fahrenheit")
        self.assertEqual(params["wind_speed_unit"], "mph")

    def test_unknown_city_stops_before_forecast(self):
        with patch("weather.get_json", return_value={}) as request:
            with self.assertRaisesRegex(ValueError, "City not found"):
                fetch_weather("unknown")
        self.assertEqual(request.call_count, 1)

    def test_missing_temperature_is_rejected(self):
        place = {"results": [{"name": "York", "latitude": 54, "longitude": -1}]}
        with patch(
            "weather.get_json",
            side_effect=[place, {"current": {"temperature_2m": None}}],
        ):
            with self.assertRaisesRegex(ValueError, "incomplete"):
                fetch_weather("York")


if __name__ == "__main__":
    unittest.main()
