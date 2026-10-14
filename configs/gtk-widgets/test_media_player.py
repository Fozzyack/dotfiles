"""Media discovery and data checks without a running player or display."""

import unittest
from unittest.mock import patch

from media_player import PREFIX, artwork, duration, snapshot


class MediaTests(unittest.TestCase):
    def test_empty_session_does_not_request_metadata(self):
        with patch("media_player.call", return_value=(["org.example.Other"],)) as call:
            self.assertEqual(snapshot(object()), ([], None, {}))
        self.assertEqual(call.call_count, 1)

    def test_explicit_player_selection(self):
        first, second = PREFIX + "a", PREFIX + "b"
        properties = {"PlaybackStatus": "Paused", "Metadata": {"xesam:title": "Song"}}
        with patch(
            "media_player.call", side_effect=[([second, first],), (properties,)]
        ) as call:
            names, selected, result = snapshot(object(), second)
        self.assertEqual(names, [first, second])
        self.assertEqual(selected, second)
        self.assertEqual(result, properties)
        self.assertEqual(call.call_args.args[1], second)

    def test_closed_player_falls_back_to_available_player(self):
        with patch("media_player.call", side_effect=[([PREFIX + "new"],), ({},)]):
            self.assertEqual(snapshot(object(), PREFIX + "old")[1], PREFIX + "new")

    def test_duration_handles_live_streams_and_long_tracks(self):
        self.assertEqual(duration(None), "0:00")
        self.assertEqual(duration(-1000000), "0:00")
        self.assertEqual(duration(65000000), "1:05")
        self.assertEqual(duration(3661000000), "1:01:01")

    def test_unsupported_artwork_uses_fallback(self):
        self.assertIsNone(artwork("spotify:track:123"))
        self.assertIsNone(artwork("file://remote-server/cover.png"))


if __name__ == "__main__":
    unittest.main()
