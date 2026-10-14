function fastfetch --description 'Fastfetch with terminal-aware native image rendering'
    set -l config_home "$HOME/.config"
    if set -q XDG_CONFIG_HOME; and test -n "$XDG_CONFIG_HOME"
        set config_home "$XDG_CONFIG_HOME"
    end
    command python3 "$config_home/fastfetch/fastfetch.py" $argv
end
