#!/bin/bash

sudo apt remove --purge -y polybar rofi dbus-x11

sudo  rm -rf ~/.config/polybar

sudo rm -f ~/.config/autostart/polybar.desktop

sudo killall grep polybar

echo "Rice desinstalado com sucesso!"
