if status is-interactive # Commands to run in interactive sessions can go here
end

# Adding to the path
export PATH="$PATH:/home/fozzyack/.dotnet/tools"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$PATH:/home/fozzyack/.runnables/zen"
export PATH="$PATH:/home/fozzyack/.config/emacs/bin"

# Fastfetch (displays system info)
fastfetch

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# fzf setup -- fzf.fish (plugin required)
fzf --fish | source
fzf_configure_bindings --history=\cr --directory=\cf --variables=\cv --git_log=\ch --git_status=\cg


#  some extra things
alias ls exa
function ff; source ~/dotfiles/ff/ff.fish $argv; end
function dfile; ~/dotfiles/dfile/dfile $argv; end

# Prompt manager
starship init fish | source

# For GPG keys to work (git stuff)
set -x GPG_TTY (tty)
