"""Network accounting checks without a display or real traffic."""

import unittest
from unittest.mock import patch

from network import automatic_interface, format_bytes, rates, read_counters, trace


class NetworkTests(unittest.TestCase):
    def test_counters_use_bytes_and_exclude_loopback(self):
        text = "header\nheader\n lo: 99 1 0 0 0 0 0 0 88 1 0 0 0 0 0 0\n eth0: 2048 2 0 0 0 0 0 0 4096 3 0 0 0 0 0 0\n"
        with patch("network.Path.read_text", return_value=text):
            self.assertEqual(read_counters(), {"eth0": (2048, 4096)})

    def test_actual_sample_interval_and_idle_traffic(self):
        self.assertEqual(rates((100, 200), (400, 800), 2), (150, 300))
        self.assertEqual(rates((100, 200), (100, 200), 1), (0, 0))

    def test_reset_and_first_sample_have_no_rate(self):
        self.assertIsNone(rates(None, (100, 200), 1))
        self.assertIsNone(rates((100, 200), (99, 300), 1))
        self.assertIsNone(rates((100, 200), (200, 300), 0))

    def test_default_route_uses_lowest_metric(self):
        routes = "header\nwlan0 00000000 01000000 0003 0 0 600 00000000\neth0 00000000 01000000 0003 0 0 100 00000000\n"
        with patch("network.Path.read_text", return_value=routes):
            self.assertEqual(
                automatic_interface({"eth0": (0, 0), "wlan0": (999, 999)}), "eth0"
            )

    def test_missing_routes_fall_back_and_empty_host_is_supported(self):
        with patch("network.Path.read_text", side_effect=OSError):
            self.assertEqual(
                automatic_interface({"eth0": (1, 1), "wlan0": (50, 50)}), "wlan0"
            )
            self.assertIsNone(automatic_interface({}))

    def test_trace_scaling_and_binary_units(self):
        graph, ceiling = trace([0, 2048])
        self.assertEqual(len(graph), 30)
        self.assertEqual(graph[-2:], "▁█")
        self.assertEqual(ceiling, 2048)
        self.assertEqual(trace([]), ("·" * 30, 1024))
        self.assertEqual(format_bytes(1048576), "1.0 MiB")


if __name__ == "__main__":
    unittest.main()
