#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
fish_config=${XDG_CONFIG_HOME:-$HOME/.config}/fish
fish_shell=/usr/bin/fish
user=$(id -un)

if [[ $(id -u) == 0 ]]; then
    echo 'Run the VM installer as your normal user, not with sudo.' >&2
    exit 1
fi
if [[ $(readlink -f -- "$fish_config") != "$(readlink -f -- "$repo_dir/vm/configs/fish")" ]]; then
    echo 'Run Setup VM first; the Fish config must link to vm/configs/fish.' >&2
    exit 1
fi
if [[ ! -x $fish_shell ]] || ! grep -Fxq -- "$fish_shell" /etc/shells; then
    echo '/usr/bin/fish must be installed and listed in /etc/shells. Login shell unchanged.' >&2
    exit 1
fi

for dependency in curl tar go fzf fd bat eza starship fastfetch python; do
    if ! command -v "$dependency" >/dev/null; then
        echo "Missing dependency: $dependency. Install VM packages first." >&2
        exit 1
    fi
done

"$fish_shell" --no-config --no-execute "$fish_config/config.fish" || {
    echo 'Fish config syntax check failed. Login shell unchanged.' >&2
    exit 1
}

# Do this separately: --no-config skips loading Fisher's universal state.
"$fish_shell" --no-config -c 'set --erase --universal fish_function_path; set --erase --universal fish_complete_path; true'

log=$(mktemp)
trap 'rm -f -- "$log"' EXIT
# CI allows fzf.fish's install hooks to run in a non-interactive shell.
# Fisher can print download/conflict errors without returning a failure code.
CI=true "$fish_shell" -c 'source "$__fish_config_dir/functions/fisher.fish"; and fisher update </dev/null' >"$log" 2>&1 || {
    cat -- "$log" >&2
    echo 'Fisher failed. Login shell unchanged.' >&2
    exit 1
}
cat -- "$log"
if grep -q '^fisher:' "$log"; then
    echo 'Fisher reported an error. Login shell unchanged.' >&2
    exit 1
fi

# Exercise the actual user config, without CI masking non-interactive issues.
# A PTY also tests the terminal-only startup path used at console login.
python - "$fish_shell" <<'PY'
import os
import pty
import subprocess
import sys
import threading

env = os.environ.copy()
env.pop("CI", None)
env.setdefault("TERM", "xterm-256color")
marker = "VM_FISH_STARTUP_OK"
command = (
    "functions -q fisher fzf_configure_bindings fish_greeting; "
    "and command -q go fzf fd bat eza starship fastfetch; "
    f"and printf '\\n{marker}\\n'"
)
for interactive in (False, True):
    master, slave = pty.openpty()
    output = bytearray()
    def drain():
        try:
            while True:
                chunk = os.read(master, 65536)
                if not chunk:
                    break
                output.extend(chunk)
        except OSError:  # Linux PTYs report EIO when the slave closes.
            pass
    reader = threading.Thread(target=drain, daemon=True)
    reader.start()
    args = [sys.argv[1], "--login"]
    if interactive:
        args.append("--interactive")
    args.extend(["-c", command])
    try:
        result = subprocess.run(
            args, stdin=slave, stdout=slave, stderr=slave,
            env=env, timeout=60,
        )
    except subprocess.TimeoutExpired:
        raise SystemExit("Fish startup timed out. Login shell unchanged.")
    finally:
        os.close(slave)
        reader.join(timeout=2)
        os.close(master)
    text = output.decode(errors="replace")
    startup_error = "called during startup" in text or "Unknown command" in text
    if result.returncode != 0 or marker not in text or startup_error:
        print(text, file=sys.stderr)
        raise SystemExit("Fish startup check failed. Login shell unchanged.")
print("Fish login and interactive startup checks passed.")
PY

# Never switch the login shell until every setup and startup check succeeds.
if [[ $(getent passwd "$user" | cut -d: -f7) != "$fish_shell" ]]; then
    sudo chsh -s "$fish_shell" "$user"
fi
echo 'Fish is configured as your default shell. Log out and back in to use it.'
