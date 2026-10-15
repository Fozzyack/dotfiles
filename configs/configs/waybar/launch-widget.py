#!/usr/bin/env python3
"""Launch one desktop widget from Waybar without tying it to the bar's lifetime."""

import argparse
import os
from pathlib import Path
import subprocess
import sys


SCRIPTS = {
    "clock": "clock.py",
    "calendar": "calendar_widget.py",
    "weather": "weather.py",
    "system": "system_load.py",
    "network": "network.py",
    "pomodoro": "pomodoro.py",
    "media": "media_player.py",
}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("widget", choices=SCRIPTS)
    parser.add_argument("--city", default="Perth", help="City when launching weather")
    args = parser.parse_args()
    # Resolving the symlink keeps this working when the dotfiles repo is moved.
    root = Path(__file__).resolve().parents[2] / "gtk-widgets"
    script = root / SCRIPTS[args.widget]
    if not script.is_file():
        parser.error(
            f"Widget not found: {script}; link the Waybar directory from this repository"
        )
    logs = (
        Path(os.environ.get("XDG_STATE_HOME", str(Path.home() / ".local/state")))
        / "retro-widgets"
    )
    logs.mkdir(parents=True, exist_ok=True)
    command = [sys.executable, str(script)]
    if args.widget == "weather":
        command += ["--city", args.city]
    with (logs / f"{script.stem}.log").open("a") as log:
        subprocess.Popen(
            command,
            cwd=root,
            env={**os.environ, "GDK_BACKEND": "wayland"},
            stdin=subprocess.DEVNULL,
            stdout=log,
            stderr=log,
            start_new_session=True,
        )


if __name__ == "__main__":
    main()
