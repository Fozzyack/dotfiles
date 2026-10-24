# Temperz links Pi's config to ~/.config/pi, not Pi's default ~/.pi/agent.
# Preserve explicit overrides (including inherited values in nested shells).
if not set -q PI_CODING_AGENT_DIR
    set -l config_home "$HOME/.config"
    if set -q XDG_CONFIG_HOME; and test -n "$XDG_CONFIG_HOME"
        set config_home "$XDG_CONFIG_HOME"
    end
    set -gx PI_CODING_AGENT_DIR "$config_home/pi"
end

# Keep session transcripts outside the symlinked dotfiles directory.
if not set -q PI_CODING_AGENT_SESSION_DIR
    set -l state_home "$HOME/.local/state"
    if set -q XDG_STATE_HOME; and test -n "$XDG_STATE_HOME"
        set state_home "$XDG_STATE_HOME"
    end
    set -gx PI_CODING_AGENT_SESSION_DIR "$state_home/pi/sessions"
end
