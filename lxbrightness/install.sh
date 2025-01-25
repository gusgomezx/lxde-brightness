#!/bin/bash

desktop_file="lxbrightness.desktop"
script_file="lxbrightness.sh"

desktop_dest="/usr/share/applications/$desktop_file"
script_dest="/opt/lxbrightness.sh"

if [ -f "$desktop_file" ]; then
    sudo cp "$desktop_file" "$desktop_dest"
    echo " $desktop_file a $desktop_dest"
else
    echo "$desktop_file not found."
fi

if [ -f "$script_file" ]; then
    sudo cp "$script_file" "$script_dest"
    echo "Copy $script_file to $script_dest"
else
    echo "$script_file not found."
fi

if [ -f "$script_dest" ]; then
    sudo chmod +x "$script_dest"
else
    echo "error permissions, file not found."
fi
