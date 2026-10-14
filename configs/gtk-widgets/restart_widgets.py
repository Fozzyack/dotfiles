#!/usr/bin/env python3
"""Restart this project's widgets, preserving arguments of running instances."""

import argparse
import os
from pathlib import Path
import signal
import subprocess
import sys
import time


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--city", help="Override the weather city")
    args = parser.parse_args()
    root = Path(__file__).resolve().parent
    scripts = (
        "clock.py",
        "calendar_widget.py",
        "weather.py",
        "system_load.py",
        "network.py",
        "pomodoro.py",
    )
    # Stop the optional media deck on restart, but only launch it manually.
    managed_scripts = (*scripts, "media_player.py")
    arguments = {}
    processes = []
    for proc in Path("/proc").iterdir():
        if not proc.name.isdigit():
            continue
        try:
            if proc.stat().st_uid != os.getuid():
                continue
            command = proc.joinpath("cmdline").read_bytes().decode().split("\0")
            if len(command) < 2 or not Path(command[0]).name.startswith("python"):
                continue
            script = Path(command[1])
            if not script.is_absolute():
                script = proc.joinpath("cwd").resolve() / script
            script = script.resolve()
            if script.parent != root or script.name not in managed_scripts:
                continue
            arguments[script.name] = [arg for arg in command[2:] if arg]
            processes.append(int(proc.name))
        except (OSError, UnicodeError):
            continue

    for pid in processes:
        try:
            os.kill(pid, signal.SIGTERM)
        except ProcessLookupError:
            pass
    deadline = time.monotonic() + 5
    while time.monotonic() < deadline:
        alive = []
        for pid in processes:
            try:
                state = (
                    Path(f"/proc/{pid}/stat").read_text().rsplit(")", 1)[1].split()[0]
                )
                if state != "Z":
                    alive.append(pid)
            except FileNotFoundError:
                pass
        if not alive:
            break
        time.sleep(0.1)
    else:
        raise SystemExit(
            "Some widgets did not stop; restart cancelled. Try again shortly."
        )

    logs = (
        Path(os.environ.get("XDG_STATE_HOME", str(Path.home() / ".local/state")))
        / "retro-widgets"
    )
    logs.mkdir(parents=True, exist_ok=True)
    for script in scripts:
        extra = arguments.get(script, [])
        if script == "weather.py" and args.city:
            extra = ["--city", args.city] + (
                ["--fahrenheit"] if "--fahrenheit" in extra else []
            )
        with (logs / f"{Path(script).stem}.log").open("w") as log:
            subprocess.Popen(
                [sys.executable, str(root / script), *extra],
                cwd=root,
                env={**os.environ, "GDK_BACKEND": "wayland"},
                stdin=subprocess.DEVNULL,
                stdout=log,
                stderr=log,
                start_new_session=True,
            )
        print(f"Started {script}")
    print(f"Logs: {logs}")


if __name__ == "__main__":
    main()
