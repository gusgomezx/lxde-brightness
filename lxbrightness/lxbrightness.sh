#!/bin/bash

# Obtener el nombre de la salida de la pantalla conectada
output=$(xrandr --query | grep " connected" | awk '{ print $1 }')

# Función para ajustar el brillo
set_brightness() {
    xrandr --output "$output" --brightness "$1"
}

# Bucle para permitir al usuario ingresar el brillo
while true; do
    # Pedir al usuario que ingrese un valor de brillo
    brightness=$(zenity --entry --title="Ajustar Brillo" --text="Ingrese un valor de brillo (0.2 - 1.0):")

    # Verificar si el usuario canceló
    if [ $? -ne 0 ]; then
        break
    fi

    # Validar el valor ingresado
    if [[ "$brightness" =~ ^[0-1](\.[0-9]+)?$ ]]; then
        if (( $(echo "$brightness >= 0.2" | bc -l) && $(echo "$brightness <= 1.0" | bc -l) )); then
            set_brightness "$brightness"
        else
            zenity --error --text="Por favor, ingrese un valor entre 0.2 y 1.0."
        fi
    else
        zenity --error --text="Por favor, ingrese un valor válido entre 0.2 y 1.0."
    fi
done
