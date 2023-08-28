#!/bin/bash

session="IDE"

initdir=$(pwd)
workdir=$(dirname "$0")
cd "$workdir"

tmux \
	new-session -s "$session" \; \
	send-keys 'nnn -c '"$initdir"' -f -o -e' Enter \; \
	split-window -c "$initdir" -v -p 15  \; \
	select-pane -t 1 \; \
	split-window -c "$initdir" -h -p 85 hx \; \
