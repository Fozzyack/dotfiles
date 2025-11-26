if status is-interactive # Commands to run in interactive sessions can go here
end

function ff; source ~/dotfiles/ff/ff.fish $argv; end
function dfile; ~/dotfiles/dfile/dfile $argv; end
alias ls exa
oh-my-posh init fish --config ~/dotfiles/oh-my-posh/havix.omp.json | source

export PATH="$PATH:/home/fozzyack/.dotnet/tools"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$PATH:/home/fozzyack/.runnables/zen"
export PATH="$PATH:/home/fozzyack/.config/emacs/bin"

# Set up fzf key bindings
fzf --fish | source

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

fastfetch

set -x GPG_TTY (tty)
