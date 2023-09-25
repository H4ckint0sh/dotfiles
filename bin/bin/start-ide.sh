#!/bin/bash


INITDIR=$(pwd)
WORKDIR=$(dirname "$0")
cd "$WORKDIR"

SESSION=$(basename "$INITDIR")

tmux \
	new-session -s "$SESSION" \; \
	send-keys 'nnn -c '"$INITDIR"' -f -o -e' Enter \; \
	split-window -c "$INITDIR" -h -p 85 hx \; \
	send-keys 'hx' Enter \; \
	send-keys " " "f" \; \
	new-window -c "$INITDIR" -d \; \
