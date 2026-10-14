"""Pomodoro timing and configuration checks without a display."""

import unittest
from pathlib import Path
from unittest.mock import patch

from pomodoro import Countdown, DEFAULTS, load_settings


class PomodoroTests(unittest.TestCase):
    def test_pause_resume_excludes_paused_time(self):
        timer = Countdown(DEFAULTS)
        timer.toggle(100)
        timer.toggle(160)
        self.assertEqual(timer.remaining, 24 * 60)
        timer.update(1000)
        self.assertEqual(timer.remaining, 24 * 60)
        timer.toggle(1000)
        self.assertIsNone(timer.update(2439))
        self.assertEqual(timer.update(2440), "focus")
        self.assertEqual(timer.phase, "short_break")
        self.assertIsNone(timer.deadline)

    def test_four_focus_sessions_get_long_break(self):
        timer = Countdown({"focus": 1, "short_break": 1, "long_break": 3})
        now = 0
        for session in range(1, 5):
            timer.toggle(now)
            now += 60
            self.assertEqual(timer.update(now), "focus")
            self.assertEqual(timer.completed, session)
            self.assertEqual(
                timer.phase, "long_break" if session == 4 else "short_break"
            )
            timer.toggle(now)
            now += timer.duration
            timer.update(now)
            self.assertEqual(timer.phase, "focus")

    def test_late_callback_does_not_skip_unattended_sessions(self):
        timer = Countdown(DEFAULTS)
        timer.toggle(0)
        self.assertEqual(timer.toggle(99999), "focus")
        self.assertEqual(timer.completed, 1)
        self.assertIsNone(timer.deadline)
        self.assertEqual(timer.remaining, 300)
        self.assertIsNone(timer.update(100000))
        timer.reset()
        self.assertEqual(timer.remaining, 1500)
        self.assertEqual(timer.completed, 0)

    def test_invalid_settings_fall_back_per_field(self):
        with patch.object(
            Path,
            "read_text",
            return_value='{"focus": 40, "short_break": 0, "long_break": true}',
        ):
            self.assertEqual(
                load_settings(Path("unused")),
                {"focus": 40, "short_break": 5, "long_break": 15},
            )
        for text in ("broken json", "[]", "null"):
            with patch.object(Path, "read_text", return_value=text):
                self.assertEqual(load_settings(Path("unused")), DEFAULTS)


if __name__ == "__main__":
    unittest.main()
