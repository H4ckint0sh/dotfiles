#!/bin/bash

list_data="#{pane_index} #{pane_current_command}"


helix_pane_index=$(tmux list-panes -a -F "$list_data" | grep "hx" | awk '{print $1}')

if [ -n "$helix_pane_index" ]; then

  # change to helix pane
  tmux select-pane -t $helix_pane_index

  # Send ":" to start command input in Helix
  tmux send-keys ":"

  # Send the "open" command with file path(s) to the pane and simulate Enter
  tmux send-keys "reload-all" C-m

else  

  # Helix is not running
  echo "Helix is not runnning"
  
fi


