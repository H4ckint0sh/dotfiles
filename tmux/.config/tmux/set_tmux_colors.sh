#!/usr/bin/env bash

# Source the colorscheme file
source "$HOME/colorscheme/active/active-colorscheme.sh"

tmux set -g status-left                  "#[fg=$h4ckint0sh_color02,bold]#S"
tmux set -ga status-left                 "#[fg=$h4ckint0sh_color14]#(gitmux -cfg $HOME/gitmux.conf '#{pane_current_path}') "
tmux set -g window-status-current-format "   #[fg=$h4ckint0sh_color14]#I:#{pane_current_command}"
tmux set -g window-status-format         "   #[fg=$comment]#I:#{pane_current_command}"
tmux set -g status-style "bg=default,fg=$h4ckint0sh_color14" # transparent status bar
tmux set -g status-position top
tmux set -g status-right-length 100
tmux set -g status-right '#[fg=$h4ckint0sh_color14,bg=default]#(~/.tmux/plugins/tmux-mem-cpu-load/tmux-mem-cpu-load --interval 2)#[default] %a %d/%m %H:%M:%S '



