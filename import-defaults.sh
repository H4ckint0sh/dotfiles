#!/usr/bin/env bash

function importDefaults {
    local zipPath=$1
    local extractDir="$HOME/defaults"
    local appleDir="$extractDir/apple"
    local userDir="$extractDir/user"
    local globalDir="$extractDir/global"
    local filesTotal=0

    function importDomains {
        local dir=$1
        local filesImported=0
        local filesCount=$(ls -1 "$dir"/*.plist 2>/dev/null | wc -l)
        local filesRemaining=$filesCount
        local dirName=$(basename "$dir")
        echo "$dirName namespace has $filesCount files, importing..."

        for plist in "$dir"/*.plist; do
            domain=$(basename "$plist" .plist)
            if [[ $dir == "$globalDir" ]]; then
                sudo defaults import "$domain" "$plist"
            else
                defaults import "$domain" "$plist"
            fi
            filesRemaining=$((filesRemaining-1))
            filesImported=$((filesImported+1))
            echo -ne "[ $filesImported/$filesRemaining ] \r"
        done

        filesTotal=$((filesTotal+filesCount))
        echo -e "Imported $filesCount files from the $dirName namespace.\n"
    }

    if [[ -d "$extractDir" && -n "$(ls -A "$extractDir")" ]]; then
        echo "The extraction directory '$extractDir' is not empty."
        read -p "Do you want to delete the directory and continue? (y/N): " confirmDelete
        if [[ $confirmDelete == [Yy] ]]; then
            rm -rf "$extractDir"
            echo -e "Deleted the existing directory '$extractDir'.\n"
        else
            echo "Script canceled. Exiting..."
            exit 0
        fi
    fi

    # Extract the zip file
    unzip -q "$zipPath" -d "$extractDir"

    # Import plist files in the apple directory
    importDomains "$appleDir"

    # Import plist files in the user directory
    importDomains "$userDir"

    # Import plist files in the global directory
    importDomains "$globalDir"

    echo "Defaults import completed. Imported a total of $filesTotal files."
}

if [ -z "$1" ]; then
    echo "Please provide the path to the zip file."
else
    importDefaults "$1"
fi
