#!/bin/bash

status=$(playerctl status 2>/dev/null)

case "$status" in
  "Playing") icon="" ;;  # Pause
  "Paused")  icon="" ;;  # Play
  *) exit 0 ;;
esac

title=$(playerctl metadata title 2>/dev/null)
artist=$(playerctl metadata artist 2>/dev/null)

# Botões no início, depois música
echo " $title - $artist %{A1:playerctl previous:}%{A} %{A1:playerctl play-pause:}$icon%{A} %{A1:playerctl next:}%{A}"

