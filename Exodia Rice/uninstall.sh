#!/bin/bash

sudo apt remove --purge -y polybar rofi

rm -rf ~/.config/polybar

rm -f ~/.config/autostart/polybar.desktop

echo "Rice desinstalado com sucesso!"
