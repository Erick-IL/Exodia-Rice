#!/bin/bash

sudo apt install polybar rofi dbus-x11 -y

if [ -f "$HOME/.config/polybar" ]; then
    rm -f "$HOME/.config/polybar"
fi



sudo mkdir -p ~/.config
sudo cp -r polybar ~/.config/

sudo mkdir -p ~/.config/autostart
sudo cp polybar.desktop ~/.config/autostart/

sudo chmod a+r ~/.config/polybar/menu.rasi
sudo chmod a+r ~/.config/polybar/scripts/powermenu.rasi
sudo chmod a+r ~/.config/polybar/scripts/choose_theme.rasi

NOME1="Abrir GNOME Terminal"
COMANDO1="gnome-terminal"
ATALHO1="<Super>Return"

NOME2="Abrir menu"
COMANDO2="$HOME/.config/polybar/scripts/menu.sh"
ATALHO2="<Super>q"

EXISTENTES=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)

if [[ $EXISTENTES == "[]" ]]; then
    BINDINGS=()
else
    BINDINGS=()
    EXISTENTES_CLEAN=$(echo $EXISTENTES | sed -e "s/^\[//" -e "s/\]$//" -e "s/'//g" -e "s/ //g")
    IFS=',' read -ra BINDINGS <<< "$EXISTENTES_CLEAN"
fi

IDX1=${#BINDINGS[@]}
IDX2=$((IDX1 + 1))

PATH1="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$IDX1/"
PATH2="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$IDX2/"

NOVOS_BINDINGS=("${BINDINGS[@]}" "$PATH1" "$PATH2")


NOVOS_BINDINGS_STRING=$(printf "'%s'," "${NOVOS_BINDINGS[@]}")
NOVOS_BINDINGS_STRING="[${NOVOS_BINDINGS_STRING%,}]" 

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$NOVOS_BINDINGS_STRING"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH1 name "$NOME1"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH1 command "$COMANDO1"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH1 binding "$ATALHO1"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH2 name "$NOME2"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH2 command "$COMANDO2"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH2 binding "$ATALHO2"

sudo ~/.config/polybar/launch.sh

echo "Rice instalado com sucesso!"
