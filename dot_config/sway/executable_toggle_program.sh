#!/usr/bin/env bash
# generalized program to "toggle" the instance (dead/alive) of a program
# launches a new program each time, only one instance of target program will be allowed

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <program_name> [program_args...]"
    exit 1
fi

path="$1"
name="$(basename "$path")"
shift

# store pid of proc with name
pidfile="/tmp/toggle_${name}.pid"

if [[ -f "$pidfile" ]] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
    kill "$(cat "$pidfile")"
    rm -f "$pidfile"
else
    "$path" "$@" &>/dev/null &
    echo $! >"$pidfile"
fi
