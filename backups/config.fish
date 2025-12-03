if status is-interactive # Commands to run in interactive sessions can go here
end

# Adding to the path
export PATH="$PATH:/home/fozzyack/.dotnet/tools"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$PATH:/home/fozzyack/.runnables/zen"
export PATH="$PATH:/home/fozzyack/.config/emacs/bin"

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# fzf setup -- fzf.fish (plugin required)
fzf --fish | source
fzf_configure_bindings --history=\cr --directory=\cf --variables=\cv --git_log=\ch --git_status=\cg

#  extra things
function ff; source ~/dotfiles/ff/ff.fish $argv; end
function dfile; ~/dotfiles/dfile/dfile $argv; end

# Prompt manager
starship init fish | source

# For GPG keys to work (git stuff)
set -x GPG_TTY (tty)

# ALIASES ---------------------

# list
alias ls exa # Uses exa instead of ls
alias ll="exa -al"

# grep
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

# Navigation
alias ..="cd .."
alias ...="cd ../../../"
alias ....="cd ../../../../"

# github
alias gp="git push"
alias gpl="git pull"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit"
alias gs="git status"
alias gl="git log"
alias gd="git diff"

# ALIASES END ----------------
