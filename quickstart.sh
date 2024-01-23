#!/bin/bash

# set -e

# shellcheck source=./functions
source ./functions

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

if brew_available; then
  echo "Brewing..."
  source ./macsetup
fi

if running_macos; then
  load_brew_shellenv
fi

if running_macos; then
  echo "deleting all .DS_Store files"
  find . -name ".DS_Store" -type f -delete
fi

echo "linking your files ..."
source ./linkfolders

echo "installing files and folders ..."
source ./install

echo "Importing defaults ..."
chmod +x import-defaults.sh
sh defaults-import.sh ~/defaults/defaults.zip

echo "checking if ~/.nvm directory exists ..."
DIR=~/.nvm
if [ -d "$DIR" ];
then
    echo "$DIR directory exists, aborting nvm installation."
else
	echo "$DIR directory does not exist, installing nvm ..."
  mkdir ~/.nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  nvm install 'lts/*'
fi


echo "checking if ~/.tmux/plugins/tpm directory exists ..."
DIR=~/.tmux/plugins/tpm
if [ -d "$DIR" ];
then
  echo "$DIR directory exists, aborting tmux plugins installation."
else
  echo "$DIR directory does not exist, installing tmux plugins ..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ~/.tmux/plugins/tpm/bin/install_plugins
fi


echo "installing rust"
curl https://sh.rustup.rs -sSf | sh

echo "Kill affected applications"
for app in Safari Finder Dock Mail SystemUIServer; do killall "$app" >/dev/null 2>&1; done

echo "Done. Note that some of these changes require a logout/restart to take effect."
