#!/bin/bash


fastfetch \
  --logo "$(find ~/.config/fastfetch/images -type f | shuf -n 1)" \
  --logo-type kitty-direct \
  --logo-width 28 \
  --logo-height 18 \

echo "Press Enter or Esc to exit..."
while true; do
    read -rsn1 key
    [[ $key == "" || $key == $'\e' ]] && break
done
