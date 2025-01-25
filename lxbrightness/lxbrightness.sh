#!/bin/bash

config_file="$HOME/.brightness_config"

select_language() {
    lang=$(zenity --list --title="Select Language" --column="Language" "English" "Español")
    if [ "$lang" == "English" ]; then
        echo "en" > "$config_file"
    elif [ "$lang" == "Español" ]; then
        echo "es" > "$config_file"
    else
        exit 1
    fi
}

if [ -f "$config_file" ]; then
    language=$(cat "$config_file")
else
    language=$(select_language)
fi

if [ "$language" == "en" ]; then
    title="Adjust Brightness"
    prompt="Enter a brightness value (0.2 - 1.0):"
    error_range="Please enter a value between 0.2 and 1.0."
    error_valid="Please enter a valid value between 0.2 and 1.0."
else
    title="Ajustar Brillo"
    prompt="Ingrese un valor de brillo (0.2 - 1.0):"
    error_range="Por favor, ingrese un valor entre 0.2 y 1.0."
    error_valid="Por favor, ingrese un valor válido entre 0.2 y 1.0."
fi

output=$(xrandr --query | grep " connected" | awk '{ print $1 }')

set_brightness() {
    xrandr --output "$output" --brightness "$1"
}

while true; do
    brightness=$(zenity --entry --title="$title" --text="$prompt")

    if [ $? -ne 0 ]; then
        break
    fi

    # Validar el valor ingresado
    if [[ "$brightness" =~ ^[0-1](\.[0-9]+)?$ ]]; then
        if (( $(echo "$brightness >= 0.2" | bc -l) && $(echo "$brightness <= 1.0" | bc -l) )); then
            set_brightness "$brightness"
        else
            zenity --error --text="$error_range"
        fi
    else
        zenity --error --text="$error_valid"
    fi
done
