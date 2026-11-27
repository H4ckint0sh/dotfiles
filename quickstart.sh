#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

STOW_FOLDERS="exported-defaults,lazygit,rift,rex,zsh,ohmyposh,eza,git,bin,nvim,karabiner,bat,bash,gitu,helix,zed,ssh"
DOTFILES=~/.dotfiles

running_macos() {
  [ "$(uname)" == Darwin ]
}

command_available() {
  which "$1" >/dev/null 2>&1
}

brew_available() {
  command_available brew
}

load_brew_shellenv() {
  if test -x /opt/homebrew/bin/brew; then
    brew=/opt/homebrew/bin/brew
  elif test -x /usr/local/bin/brew; then
    brew=/usr/local/bin/brew
  fi

  if test -n "${brew}"; then
    eval "$($brew shellenv)"
  fi
}

on_ac_power() {
  pmset -g ps 2>/dev/null | grep -q "AC Power"
}

# Prevent sleeping during script execution (macOS on AC only)
if running_macos && on_ac_power; then
  caffeinate -s -w $$ &
  CAFFEINATE_PID=$!
  trap "kill $CAFFEINATE_PID 2>/dev/null" EXIT
fi

# Install Homebrew if not available
if ! brew_available; then
  echo "Homebrew not found, installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_brew_shellenv
else
  echo "Homebrew already installed."
fi

# Run brew bundle if Homebrew is available (skip if lockfile unchanged)
if brew_available; then
  echo "Brewing and setting up macOS..."
  brew update
  brew upgrade

  if brew bundle check 2>/dev/null; then
    echo "Brewfile unchanged, skipping bundle install."
  else
    brew bundle
  fi

  # Remove default .zshrc if it exists and isn't our symlink
  FILE=~/.zshrc
  if test -f "$FILE" && ! test -L "$FILE"; then
    rm "$FILE"
    echo "Removed default ~/.zshrc"
  fi
fi

# Clean up .DS_Store files on macOS
if running_macos; then
  echo "Deleting all .DS_Store files..."
  find . -name ".DS_Store" -type f -delete 2>/dev/null
fi

echo "Linking dotfiles..."
pushd "$DOTFILES" >/dev/null

# Stow in parallel, collect failures
# Use --adopt for folders that commonly have pre-existing configs
ADOPT_FOLDERS="ssh"

FAILED_FOLDERS=()
PIDS=()
FOLDERS=()
for folder in ${STOW_FOLDERS//,/ }; do
  (
    stow -D "$folder" 2>/dev/null
    if [[ " $ADOPT_FOLDERS " == *" $folder "* ]]; then
      if ! stow --adopt "$folder"; then
        echo "FAILED: $folder" >&2
        exit 1
      fi
    else
      if ! stow "$folder"; then
        echo "FAILED: $folder" >&2
        exit 1
      fi
    fi
  ) &
  PIDS+=($!)
  FOLDERS+=("$folder")
done

# Wait for all stow jobs, collect failures
for i in "${!PIDS[@]}"; do
  if ! wait "${PIDS[i]}"; then
    FAILED_FOLDERS+=("${FOLDERS[i]}")
  fi
done

popd >/dev/null

if [ ${#FAILED_FOLDERS[@]} -gt 0 ]; then
  echo "Warning: Failed to stow: ${FAILED_FOLDERS[*]}"
fi

echo "Importing defaults..."
./import-defaults.sh ~/defaults.zip --force

# Rex app settings the config in rex/ relies on (not in defaults.zip)
echo "Setting Rex app preferences..."
# Settings > General "Let Rex and other clients perform actions in this app":
# lets the startup session picker (bin/rex-session-init) switch sessions
defaults write com.superlogical.rex rex.client.remoteControl -bool true
# don't even out every pane on each split (keeps the 75/25 session layout)
defaults write com.superlogical.rex Workspace.balancesSplitsOnCreation -bool false
# overlay scroll bars that only show while scrolling (with a mouse attached
# macOS otherwise draws thick always-visible ones, e.g. beside nvim)
defaults write com.superlogical.rex AppleShowScrollBars -string WhenScrolling
# open the "Sessions" picker every time Rex starts (launchd agent)
"$HOME/bin/rex-startup-picker" install
# the Nord theme (matches nvim) and font need the app running: open Rex, then
echo "Rex: once Rex.app is open, run 'rex do appearance' to apply the Nord theme and font"

echo "Installing Rust..."
if command -v rustup &> /dev/null; then
  echo "Rust is already installed. Updating..."
  rustup update
else
  echo "Rust not found, installing via rustup.rs (minimal profile)..."
  curl https://sh.rustup.rs -sSf | sh -s -- -y --profile minimal
  # Source cargo env for immediate use
  if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
  fi
fi

echo "Killing affected applications..."
if running_macos; then
  for app in Safari Finder Dock Mail SystemUIServer; do
    if pgrep -x "$app" > /dev/null; then
      killall "$app" >/dev/null 2>&1
      echo "Killed $app."
    fi
  done
fi

echo "Done. Note that some of these changes require a logout/restart to take effect."