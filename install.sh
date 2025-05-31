#!/bin/bash
#!/bin/bash

sudo apt install polybar rofi

cp polybar ~/.config/

cp polybar.desktop ~/.config/autostart/


NOME1="Abrir GNOME Terminal"
COMANDO1="gnome-terminal"
ATALHO1="<Control>Return"

NOME2="Abrir menu"
COMANDO2="~/.config/polybar/scipts/menu.sh"
ATALHO2="<Super>q"

EXISTENTES=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)

IFS=',' read -ra BINDINGS <<< "$(echo $EXISTENTES | sed -e "s/[\[\]']//g")"

IDX1=${#BINDINGS[@]}
IDX2=$((IDX1 + 1))

PATH1="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$IDX1/"
PATH2="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$IDX2/"

NOVOS_BINDINGS=("${BINDINGS[@]}" "'$PATH1'" "'$PATH2'")
NOVOS_BINDINGS_STRING="[${NOVOS_BINDINGS[*]}]"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$NOVOS_BINDINGS_STRING"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH1 name "$NOME1"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH1 command "$COMANDO1"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH1 binding "$ATALHO1"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH2 name "$NOME2"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH2 command "$COMANDO2"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH2 binding "$ATALHO2"

echo "Rice Instalado com sucesso!"
