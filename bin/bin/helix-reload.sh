#!/bin/bash

# Data to be listed
LIST_DATA="#{pane_index} #{pane_current_command}"

# Find pane id where helix is running
HELIX_PANE_INDEX=$(tmux list-panes -a -F "$LIST_DATA" | grep "hx" | awk '{print $1}')

if [ -n "$HELIX_PANE_INDEX" ]; then

  # change to helix pane
  tmux select-pane -t $HELIX_PANE_INDEX

  # Send ":" to start command input in Helix
  tmux send-keys ":"

  # Send the "reload-all" command to helix pane and simulate Enter
  tmux send-keys "reload-all" C-m

fi


