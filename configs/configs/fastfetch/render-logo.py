"""Build a native Ghostty/WezTerm image with tmux-aware cursor positioning."""

import base64
import os
from pathlib import Path
import subprocess
import tempfile


WIDTH = 36
HEIGHT = 18
ESC = b"\x1b"


def image_protocol(in_tmux):
    if in_tmux:
        # TERM becomes tmux-256color, and inherited environment variables can
        # still describe the terminal that originally started the server.
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
                return "kitty" if "ghostty" in terminal else "iterm"
        except (OSError, subprocess.SubprocessError):
            pass

    program = os.environ.get("TERM_PROGRAM", "").lower()
    terminal = os.environ.get("TERM", "").lower()
    if program == "ghostty" or "ghostty" in terminal:
        return "kitty"
    if program != "wezterm" and os.environ.get("GHOSTTY_RESOURCES_DIR"):
        return "kitty"
    return "iterm"


in_tmux = bool(os.environ.get("TMUX")) or os.environ.get("TERM", "").startswith(
    ("tmux", "screen")
)
protocol = image_protocol(in_tmux)
image = Path(__file__).with_name("retro-anime-cyberpunk-portrait-terminal.png")
encoded = base64.b64encode(image.read_bytes())
if protocol == "kitty":
    # Send PNG data rather than a local filename (also works across WSL/SSH).
    # C=1 keeps the cursor still; q=2 suppresses terminal replies into the shell.
    packets = []
    for offset in range(0, len(encoded), 4096):
        chunk = encoded[offset : offset + 4096]
        more = int(offset + len(chunk) < len(encoded))
        options = f"a=T,f=100,t=d,c={WIDTH},r={HEIGHT},C=1," if offset == 0 else ""
        packets.append(
            ESC + f"_G{options}q=2,m={more};".encode() + chunk + ESC + b"\\"
        )
else:
    packets = [
        ESC + b"]1337;File=inline=1;"
        + f"width={WIDTH};height={HEIGHT};preserveAspectRatio=1;doNotMoveCursor=1:".encode()
        + encoded
        + b"\x07"
    ]

# Wrap each Kitty chunk independently so every passthrough stays small.
payload = b"".join(
    ESC + b"Ptmux;" + packet.replace(ESC, ESC + ESC) + ESC + b"\\"
    if in_tmux else packet
    for packet in packets
)

# Make room before drawing, including when invoked at the bottom of a pane.
# Both protocols leave the cursor untouched while attaching the image. Saving
# and restoring it around the image is insufficient on WezTerm 20240203.
# Leave the cursor on the last image row: Fastfetch adds a newline and moves
# back up by logo.height before printing the title and modules alongside it.
raw = (
    b"\n" * HEIGHT
    + f"\x1b[{HEIGHT}A".encode()
    + payload
    + f"\x1b[{HEIGHT - 1}B".encode()
)

cache = Path(os.environ.get("XDG_CACHE_HOME") or Path.home() / ".cache") / "fastfetch"
cache.mkdir(parents=True, exist_ok=True)
suffix = "-tmux" if in_tmux else ""
target = cache / f"retro-portrait-{protocol}{suffix}.raw"
# Atomic replacement allows simultaneous shell launches to share the asset.
with tempfile.NamedTemporaryFile(dir=cache, delete=False) as output:
    output.write(raw)
    temporary = Path(output.name)
temporary.replace(target)
print(target)
