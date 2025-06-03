#!/bin/sh

# Caminhos
ROFI_THEME="$HOME/.config/polybar/scripts/theme"
THEME_DIR="$HOME/.config/polybar/themes"
POLYBAR_CONFIG="$HOME/.config/polybar/config/config.ini"
WALLPAPER_DIR="$HOME/.config/polybar/wallpapers"

# Opções
shutdown="⏻ Power Off"
reboot=" Reboot"
logout=" Logout"
suspend="⏾ Suspend"
change_theme=" Theme"

# Menu via rofi + X11 backend
chosen=$(printf "%s\n%s\n%s\n%s\n%s\n%s\n%s\n" \
  "$shutdown" "$reboot" "$logout" "$suspend" "$change_theme" \
  | GDK_BACKEND=x11 rofi -dmenu -filter "" -p "$(whoami)@$(hostname)" -theme "$ROFI_THEME/powermenu.rasi")

case "$chosen" in
  "$shutdown") systemctl poweroff ;;
  "$reboot") systemctl reboot ;;
  "$logout")
    gdbus call --session \
      --dest org.gnome.SessionManager \
      --object-path /org/gnome/SessionManager \
      --method org.gnome.SessionManager.Logout 1
    ;;
  "$suspend") systemctl suspend ;;
  "$change_theme")
    current_theme=$(grep include-file "$POLYBAR_CONFIG" | awk -F '/' '{print $NF}' | sed 's/.ini//')
    themes=$(ls "$THEME_DIR" | sed 's/.ini//')
    new_theme=$(printf "%s" "$themes" | GDK_BACKEND=x11 rofi -dmenu -p "Tema atual: $current_theme" -theme "$ROFI_THEME/choose_theme.rasi")

    if [ -n "$new_theme" ]; then
	sed -i "s|include-file = .*|include-file = $THEME_DIR/$new_theme.ini|" "$POLYBAR_CONFIG"
	sed -i "s|@import \"colors/$current_theme\.rasi\"|@import \"colors/$new_theme.rasi\"|" "$ROFI_THEME/powermenu.rasi"
	sed -i "s|@import \"colors/$current_theme\.rasi\"|@import \"colors/$new_theme.rasi\"|" "$ROFI_THEME/choose_theme.rasi"
	sed -i "s/$current_theme/$new_theme/g" "$ROFI_THEME/choose_theme.rasi"
	sed -i "s/$current_theme/$new_theme/g" "$ROFI_THEME/menu.rasi"
	sed -i "s|@import \"colors/$current_theme\.rasi\"|@import \"colors/$new_theme.rasi\"|" "$ROFI_THEME/menu.rasi"


      image_path="$WALLPAPER_DIR/$new_theme.jpeg"
      if [ -f "$image_path" ]; then
        gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
        gsettings set org.gnome.shell.extensions.user-theme name "Adwaita-dark"
        gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
        gsettings set org.gnome.desktop.background picture-uri "file://$image_path"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$image_path"
      else
        notify-send "Erro" "Imagem do tema não encontrada: $image_path"
      fi

      ~/.config/polybar/launch.sh
    fi
    ;;
  *) exit 0 ;;
esac
