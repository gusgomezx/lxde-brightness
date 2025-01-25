#!/bin/bash

desktop_file="lxbrightness.desktop"
script_file="lxbrightness.sh"

desktop_dest="$HOME/.local/share/applications/$desktop_file"
script_dest="/opt/lxbrightness.sh"

if [ -f "$desktop_file" ]; then
    mv "$desktop_file" "$desktop_dest"
    echo "Movido $desktop_file a $desktop_dest"
else
    echo "$desktop_file no encontrado."
fi

if [ -f "$script_file" ]; then
    sudo mv "$script_file" "$script_dest"
    echo "Movido $script_file a $script_dest"
else
    echo "$script_file no encontrado."
fi

if [ -f "$script_dest" ]; then
    sudo chmod +x "$script_dest"
else
    echo "Error."
fi
