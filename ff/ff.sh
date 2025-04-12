#!/bin/bash

# If you are using bash as your shell

output="$("$PWD/ffcli" "$@")"
status=$?

if [ $status -eq 5 ]; then
    echo "USAGE:"
    echo ""
    echo "ff [ DIRECTORY | [-s | --start ] | [ -h | --help ] ]"
    echo ""
    echo "ARGUMENTS:"
    echo ""
    echo "      DIRECTORY       Starting Directory"
    echo "      -s, --start     Start searching from users home directory"
    echo "      -h, --help      Print this help menu"
elif [ -d "$output" ]; then
    cd "$output"
else
    echo "$output"
fi
