"""Run Fastfetch with native Kitty (Ghostty) or Sixel (WezTerm) graphics."""

import os
from pathlib import Path
import subprocess
import sys


def image_protocol():
    in_zellij = bool(os.environ.get("ZELLIJ"))
    in_tmux = not in_zellij and (
        bool(os.environ.get("TMUX"))
        or os.environ.get("TERM", "").startswith(("tmux", "screen"))
    )
    if in_tmux:
        # Ask the attached client rather than trusting the server's inherited
        # terminal environment. Zellij must not query an outer tmux session.
        command = ["tmux", "display-message", "-p"]
        if os.environ.get("TMUX_PANE"):
            command += ["-t", os.environ["TMUX_PANE"]]
        command.append("#{client_termname}")
        try:
            result = subprocess.run(
                command, capture_output=True, text=True, timeout=2, check=True
            )
            terminal = result.stdout.strip().lower()
            if terminal:
                # Fastfetch wraps kitty-direct for tmux passthrough, unlike its
                # decoded Kitty renderer. The local host must access the PNG.
                return "kitty-direct" if "ghostty" in terminal else "sixel"
        except (OSError, subprocess.SubprocessError):
            pass

    program = os.environ.get("TERM_PROGRAM", "").lower()
    terminal = os.environ.get("TERM", "").lower()
    if program == "ghostty" or "ghostty" in terminal:
        return "kitty-direct" if in_tmux else "kitty"
    if program != "wezterm" and os.environ.get("GHOSTTY_RESOURCES_DIR"):
        return "kitty-direct" if in_tmux else "kitty"
    return "sixel"


def main():
    directory = Path(__file__).resolve().parent
    # Native Fastfetch owns rendering and dimensions.
    # User options come last so they can override these defaults.
    command = [
        "fastfetch",
        "--config", str(directory / "config.jsonc"),
        "--logo", str(directory / "retro-anime-cyberpunk-portrait-terminal.png"),
        "--logo-type", image_protocol(),
        *sys.argv[1:],
    ]
    try:
        os.execvp(command[0], command)
    except OSError as error:
        print(f"Unable to start Fastfetch: {error}", file=sys.stderr)
        return 127


if __name__ == "__main__":
    sys.exit(main())
