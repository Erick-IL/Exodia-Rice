#!/bin/bash

sudo apt remove --purge -y polybar rofi

rm -rf ~/.config/polybar

rm -f ~/.config/autostart/polybar.desktop

killall grep polybar

echo "Rice desinstalado com sucesso!"
