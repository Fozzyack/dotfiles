# Match the blinking bar in WezTerm, Ghostty, and tmux.
status is-interactive; or return

set -g fish_cursor_default line blink
set -g fish_cursor_insert line blink
set -g fish_cursor_external line blink

# Enable Fish's cursor handlers even with the default (Emacs) key bindings.
# Restore the shell cursor after applications exit and when focus returns.
fish_vi_cursor
