#!/bin/bash

config_file="$HOME/.brightness_config"
brightness_file="$HOME/.current_brightness"

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
    prompt="Select a brightness value"
    error_range="Please enter a value between 20 and 100."
    error_valid="Please enter a valid integer between 20 and 100."
    select_screen="Select Screen"
    exit_button="Exit"
else
    title="Ajustar Brillo"
    prompt="Seleccione un valor de brillo"
    error_range="Por favor, ingrese un valor entre 20 y 100."
    error_valid="Por favor, ingrese un valor válido entre 20 y 100."
    select_screen="Seleccionar Pantalla"
    exit_button="Salir"
fi

# Obtener las salidas de pantalla conectadas
outputs=$(xrandr --query | grep " connected" | awk '{ print $1 }')

# Seleccionar la pantalla
selected_output=$(zenity --list --title="$select_screen" --column="Screens" $outputs)

if [ -z "$selected_output" ]; then
    exit 1  # Salir si no se selecciona ninguna pantalla
fi

set_brightness() {
    # Convertir el valor de brillo de porcentaje a decimal
    brightness_decimal=$(echo "scale=2; $1 / 100" | bc)
    xrandr --output "$selected_output" --brightness "$brightness_decimal"
}

# Cargar el brillo actual desde el archivo, si existe
if [ -f "$brightness_file" ]; then
    brightness=$(cat "$brightness_file")
else
    brightness=100  # Valor por defecto si no existe el archivo
fi

while true; do
    # Usar zenity --scale para seleccionar el brillo como un número entero
    brightness=$(zenity --scale --title="$title" --text="$prompt" --min-value=20 --max-value=100 --value="$brightness" --step=1 --extra-button="$exit_button")

    # Comprobar si se presionó el botón de salir
    if [ $? -ne 0 ]; then
        break
    fi

    # Validar el valor ingresado
    if [[ "$brightness" =~ ^[0-9]+$ ]]; then
        if (( brightness >= 20 && brightness <= 100 )); then
            set_brightness "$brightness"
            echo "$brightness" > "$brightness_file"  # Guardar el brillo actual
        else
            zenity --error --text="$error_range"
        fi
    else
        zenity --error --text="$error_valid"
    fi
done
