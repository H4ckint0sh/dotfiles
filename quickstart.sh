#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# shellcheck source=./functions
source ./functions

if running_macos; then
  # Prevent sleeping during script execution, as long as the machine is on AC power
  # Trap to kill caffeinate when the script exits
  caffeinate -s -w $$ &
  CAFFEINATE_PID=$!
  trap "kill $CAFFEINATE_PID" EXIT
fi

echo "Making Files..."
make -f Makefile

# Install Homebrew if not available
if ! brew_available; then
  echo "Homebrew not found, installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_brew_shellenv
else
  echo "Homebrew already installed."
fi

# Run macsetup if Homebrew is available (and loaded)
if brew_available; then
  echo "Brewing and setting up macOS..."
  source ./macsetup
  # Ensure brew environment is loaded, especially after initial install
  load_brew_shellenv
fi

# Clean up .DS_Store files on macOS
if running_macos; then
  echo "Deleting all .DS_Store files..."
  find . -name ".DS_Store" -type f -delete
fi

echo "Linking your files..."
source ./linkfolders

echo "Installing files and folders..."
source ./install

echo "Importing defaults..."
./import-defaults.sh ~/defaults.zip

echo "Checking if ~/.tmux/plugins/tpm directory exists..."
DIR=~/.tmux/plugins/tpm
if [ -d "$DIR" ]; then
  echo "$DIR directory exists, skipping tmux plugins installation."
else
  echo "$DIR directory does not exist, installing tmux plugins..."
  git clone https://github.com/tmux-plugins/tpm "$DIR"
  "$DIR"/bin/install_plugins
fi

echo "Installing Rust..."
if command -v rustup &> /dev/null; then
  echo "Rust is already installed. Updating..."
  rustup update
else
  echo "Rust not found, installing via rustup.rs..."
  curl https://sh.rustup.rs -sSf | sh -s -- -y # -y for non-interactive install
fi

echo "Killing affected applications..."
# Only kill applications if running on macOS
if running_macos; then
  for app in Safari Finder Dock Mail SystemUIServer; do
    if pgrep -x "$app" > /dev/null; then
      killall "$app" >/dev/null 2>&1
      echo "Killed $app."
    fi
  done
fi

echo "Done. Note that some of these changes require a logout/restart to take effect."
