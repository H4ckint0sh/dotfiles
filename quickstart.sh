#!/bin/bash

set -e

# shellcheck source=./functions.sh
source ./functions.sh

if running_macos; then
  # Prevent sleeping during script execution, as long as the machine is on AC power
  caffeinate -s -w $$ &
fi

echo "Making Files ..."
make -f Makefile

if ! brew_available; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_brew_shellenv
fi

echo "Brewing ..."
source ./macsetup

if fish_available; then
  ./fish.sh
fi

if running_macos; then
  load_brew_shellenv

fi

echo "linking your files ..."
source ./linkfolders

echo "installing files and folders ..."
source ./install

echo "Installing nvm"
mkdir ~/.nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
nvm install 'lts/*'

echo "Installing tmux plugins"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

echo "installing rust"
curl https://sh.rustup.rs -sSf | sh

echo "Restarting affected apps"
for app in "Activity Monitor" \
    "Address Book" \
    "Calendar" \
    "cfprefsd" \
    "Contacts" \
    "Dock" \
    "Finder" \
    "Google Chrome Canary" \
    "Google Chrome" \
    "Mail" \
    "Messages" \
    "Opera" \
    "Photos" \
    "Safari" \
    "SystemUIServer" \
    "Terminal" \
    "Transmission"; do
    killall "${app}" &> /dev/null
done

echo "Done. Note that some of these changes require a logout/restart to take effect."
