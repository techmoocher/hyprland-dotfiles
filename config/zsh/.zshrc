for file in ~/.config/zsh/{exports,aliases,options,functions,keybinds,plugins}.zsh; do
  [ -r "$file" ] && source "$file"
done

eval "$(starship init zsh)"
