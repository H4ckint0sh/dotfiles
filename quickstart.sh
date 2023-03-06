#!/bin/bash

#set -e

echo "Making Files ..."
make -f Makefile

echo "Brewing ..."
source ./macsetup

echo "linking your files ..."
source ./linkfolders

echo "installing files and folders ..."
source ./install

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
