# FISH
# This is the shell script that is run when installed using dotfiles
set output ("$HOME/dotfiles/ff/ffcli" $argv)
set program_exit_status $status
if test $program_exit_status -eq 5
    echo "USAGE:"
    echo ""
    echo "ff [ DIRECTORY | [-s | --start ] | [ -h | --help ] ]"
    echo ""
    echo "ARGUMENTS:"
    echo ""
    echo "      DIRECTORY       Starting Directory"
    echo "      -s, --start     Start searching from users home directory"
    echo "      -h, --help      Print this help menu"
else if test -d $output
    cd "$output"
else
    echo "$output"
end

