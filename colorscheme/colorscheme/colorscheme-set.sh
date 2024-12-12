
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
# background = $h4ckint0sh_color10
# foreground = $h4ckint0sh_color14
#
# cursor-color = $h4ckint0sh_color24
#
# # black
# palette = 0=$h4ckint0sh_color10
# palette = 8=$h4ckint0sh_color08
# # red
# palette = 1=$h4ckint0sh_color11
# palette = 9=$h4ckint0sh_color11
# # $h4ckint0sh_color03
# palette = 2=$h4ckint0sh_color02
# palette = 10=$h4ckint0sh_color02
# # yellow
# palette = 3=$h4ckint0sh_color05
# palette = 11=$h4ckint0sh_color05
# # blue
# palette = 4=$h4ckint0sh_color04
# palette = 12=$h4ckint0sh_color04
# # purple
# palette = 5=${h4ckintosh_color01}
# palette = 13=${h4ckintosh_color01}
# # aqua
# palette = 6=$h4ckint0sh_color03
# palette = 14=$h4ckint0sh_color03
# # white
# palette = 7=$h4ckint0sh_color14
# palette = 15=$h4ckint0sh_color14
# EOF
#
#   echo "Ghostty configuration updated at '$ghostty_conf_file'."
# }

generate_starship_config() {
  # Define the path to the active-config.toml
  starship_conf_file="$HOME/.dotfiles/starship/.config/starship.toml"

  # Generate the Starship configuration file
  cat >"$starship_conf_file" <<EOF
# This will show the time on a 2nd line
# Add a "\\" at the end of an item, if you want the next item to show on the same line
format = """
\$username\\
\$directory\\
\$nodejs\\
\$time\\
\$character\\
"""

[character]
success_symbol = '[  ](${h4ckint0sh_color02} bold)'
error_symbol = '[  ](${h4ckint0sh_color11} bold)'
vicmd_symbol = '[󰕷  ](${h4ckint0sh_color04} bold)'

[directory]
style = "${h4ckintosh_color01}"
truncation_length = 3
truncation_symbol = "…/"

[battery]
disabled = true

[gcloud]
disabled = true

[time]
style = '${h4ckint0sh_color04} bold'
disabled = false
format = '[\[\$time\]](\$style) '
# https://docs.rs/chrono/0.4.7/chrono/format/strftime/index.html
# %T	00:34:60	Hour-minute-second format. Same to %H:%M:%S.
# time_format = '%y/%m/%d %T'
time_format = '%y/%m/%d'

[username]
style_user = '${h4ckint0sh_color04} bold'
style_root = 'white bold'
format = '[\$user](\$style).@.'
show_always = true

[nodejs]
symbol = ""
format = '[[\$symbol(\$version)](${h4ckint0sh_color05})](\$style)'

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
  $HOME/.config/tmux/set_tmux_colors.sh
  tmux source-file ~/.config/tmux/tmux.conf
  echo "Tmux colors set and tmux configuration reloaded."

  # Set sketchybar colors
  sketchybar --reload

  generate_starship_config
fi
