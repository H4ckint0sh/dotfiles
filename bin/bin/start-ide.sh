#!/bin/bash

SESSION="IDE"

INITDIR=$(pwd)
WORKDIR=$(dirname "$0")
cd "$WORKDIR"

tmux \
	new-session -s "$SESSION" \; \
	send-keys 'nnn -c '"$INITDIR"' -f -o -e' Enter \; \
	split-window -c "$INITDIR" -v -p 15  \; \
	select-pane -t 1 \; \
	split-window -c "$INITDIR" -h -p 85 hx \; \
