#!/usr/bin/env bash
 
PATH="$1"
 
 
# Select right pane
RIGH_PANE=$(tmux select-pane -R)
RIGHT_PNE_ID=$(tmux list-panes -t  $RIGHT_PANE -F '#{pane_id}')
RIGHT_PANES_COMMAND=$(tmux list-panes -t $RIGHT_PANE -F '#{pane_current_command}')


if [ $RIGHT_PANE_ID -eq 0 ]; then
  tmux split-window -h -l 80%
fi

tmux select-pane -L
 
if [ "$RIGHT_PANES_COMMAND" = "hx" ]; then
    # Send ":" to start command input in Helix
	tmux send-keys ":"

  # Send the "open" command with file path(s) to the pane and simulate Enter
	tmux send-keys "open $PATH" C-m
   
else
  # Send hx
	tmux send-keys "hx" C-m

  # Send ":" to start command input in Helix
	tmux send-keys ":"

  # Send the "open" command with file path(s) to the pane and simulate Enter
	tmux send-keys "open $PATH" C-m

fi

tmux select-pane -R