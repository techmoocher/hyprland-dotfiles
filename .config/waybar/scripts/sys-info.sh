#!/bin/bash


fastfetch \
  --logo $HOME/.config/waybar/assets/archlinux-girl.png \
  --logo-type kitty-direct \
  --logo-width 30 \
  --logo-height 18 \

echo "Press Enter or Esc to exit..."
while true; do
    read -rsn1 key
    [[ $key == "" || $key == $'\e' ]] && break
done
