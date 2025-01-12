
#!/usr/bin/env bash

# Filename: ~/github/dotfiles-latest/zshrc/colorscheme-set.sh
# ~/github/dotfiles-latest/zshrc/colorscheme-set.sh

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display error messages
error() {
  echo "Error: $1" >&2
  exit 1
}

# Ensure a colorscheme profile is provided
if [ -z "$1" ]; then
  error "No colorscheme profile provided"
fi

colorscheme_profile="$1"

# Define paths
colorscheme_file="$HOME/colorscheme/list/$colorscheme_profile"
active_file="$HOME/colorscheme/active/active-colorscheme.sh"

# Check if the colorscheme file exists
if [ ! -f "$colorscheme_file" ]; then
  error "Colorscheme file '$colorscheme_file' does not exist."
fi

# If active-colorscheme.sh doesn't exist, create it
if [ ! -f "$active_file" ]; then
  echo "Active colorscheme file not found. Creating '$active_file'."
  cp "$colorscheme_file" "$active_file"
  UPDATED=true
else
  # Compare the new colorscheme with the active one
  if ! diff -q "$active_file" "$colorscheme_file" >/dev/null; then
    UPDATED=true
  else
    UPDATED=false
  fi
fi

# generate_ghostty_config() {
#   ghostty_conf_file="$HOME/github/dotfiles-latest/ghostty/ghostty-theme"
#
#   cat >"$ghostty_conf_file" <<EOF
# background = $linkarzu_color10
# foreground = $linkarzu_color14
#
# cursor-color = $linkarzu_color24
#
# # black
# palette = 0=$linkarzu_color10
# palette = 8=$linkarzu_color08
# # red
# palette = 1=$linkarzu_color11
# palette = 9=$linkarzu_color11
# # green
# palette = 2=$linkarzu_color02
# palette = 10=$linkarzu_color02
# # yellow
# palette = 3=$linkarzu_color05
# palette = 11=$linkarzu_color05
# # blue
# palette = 4=$linkarzu_color04
# palette = 12=$linkarzu_color04
# # purple
# palette = 5=$linkarzu_color01
# palette = 13=$linkarzu_color01
# # aqua
# palette = 6=$linkarzu_color03
# palette = 14=$linkarzu_color03
# # white
# palette = 7=$linkarzu_color14
# palette = 15=$linkarzu_color14
# EOF
#
#   echo "Ghostty configuration updated at '$ghostty_conf_file'."
# }

generate_starship_config() {
  # Define the path to the active-config.toml
  starship_conf_file="$HOME/.config/starship.toml"

  # Generate the Starship configuration file
  cat >"$starship_conf_file" <<EOF
# This will show the time on a 2nd line
# Add a "\\" at the end of an item, if you want the next item to show on the same line
format = """
\$username\\
\$hostname\\
\$time\\
\$all\\
\$directory
\$kubernetes
\$character
"""

[character]
success_symbol = '[❯❯❯❯](${linkarzu_color02} bold)'
error_symbol = '[XXXX](${linkarzu_color11} bold)'
vicmd_symbol = '[❮❮❮❮](${linkarzu_color04} bold)'

[battery]
disabled = true

[gcloud]
disabled = true

[time]
style = '${linkarzu_color04} bold'
disabled = false
format = '[\[\$time\]](\$style) '
# https://docs.rs/chrono/0.4.7/chrono/format/strftime/index.html
# %T	00:34:60	Hour-minute-second format. Same to %H:%M:%S.
# time_format = '%y/%m/%d %T'
time_format = '%y/%m/%d'

# For this to show up correctly, you need to have cluster access
# So your ~/.kube/config needs to be configured on the local machine
[kubernetes]
disabled = false
# context = user@cluster
# format = '[\$user@\$cluster \(\$namespace\)](${linkarzu_color05}) '
# format = '[\$cluster \(\$namespace\)](${linkarzu_color05}) '
# Apply separate colors for cluster and namespace
format = '[\$cluster](${linkarzu_color05} bold) [\$namespace](${linkarzu_color02} bold) '
# format = 'on [⛵ (\$user on )(\$cluster in )\$context \(\$namespace\)](dimmed green) '
# Only dirs that have this file inside will show the kubernetes prompt
# detect_files = ['900-detectkubernetes.sh']
# detect_env_vars = ['STAR_USE_KUBE']
# contexts = [
#   { context_pattern = "dev.local.cluster.k8s", style = "green", symbol = "💔 " },
# ]

[username]
style_user = '${linkarzu_color04} bold'
style_root = 'white bold'
format = '[\$user](\$style).@.'
show_always = true

[hostname]
ssh_only = true
format = '(white bold)[\$hostname](${linkarzu_color02} bold)'

[directory]
style = '${linkarzu_color03} bold'
truncation_length = 0
truncate_to_repo = false

[ruby]
detect_variables = []
detect_files = ['Gemfile', '.ruby-version']
EOF

  echo "Starship configuration updated at '$starship_conf_file'."
}

# If there's an update, replace the active colorscheme and perform necessary actions
if [ "$UPDATED" = true ]; then
  echo "Updating active colorscheme to '$colorscheme_profile'."

  # Replace the contents of active-colorscheme.sh
  cp "$colorscheme_file" "$active_file"

  # Source the active colorscheme to load variables
  source "$active_file"

  # Set the tmux colors
  $HOME/github/dotfiles-latest/tmux/tools/linkarzu/set_tmux_colors.sh
  tmux source-file ~/.tmux.conf
  echo "Tmux colors set and tmux configuration reloaded."

  # Set sketchybar colors
  sketchybar --reload

  generate_starship_config

  # Generate the ghostty config file
  generate_ghostty_config
  osascript $HOME/github/dotfiles-latest/ghostty/reload-config.scpt

  generate_btop_config

  # Generate the Kitty configuration file
  generate_kitty_config
  # This reloads kitty config without closing and re-opening
  kill -SIGUSR1 "$(pgrep -x kitty)"

  # Also restart yabai for my skitty-notes colors
  ~/github/dotfiles-latest/yabai/yabai_restart.sh
fi
