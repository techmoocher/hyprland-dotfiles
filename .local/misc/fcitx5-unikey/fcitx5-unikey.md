# Vietnamese (VIE) Input on Arch Linux (Wayland)

## Installation

First, install `fcitx5` and its dependecies.

```bash
sudo pacman -S --needed fcitx5 fcitx5-unikey fcitx5-configtool fcitx5-gtk fcitx5-qt
```

Next, set necessary environment variables for Hyprland. Add the following to Hyprland config (normal it stays at `~/.config/hypr/hyprland.conf`)

```
# Input method (fcitx5)
env = GTK_IM_MODULE,fcitx
env = QT_IM_MODULE,fcitx
env = XMODIFIERS,@im=fcitx

# For autostarting fcitx5 at startup
exec-once = fcitx5 -d
```

## Configuration

In your terminal, type:

```bash
fcitx5-configtool
```

Add Unikey to your "Current Input Method" (the right pane).

<div align="center">
    <img src="fcitx5-preview-1.jpg" alt="Illustration for adding Unikey to Current Input Method" width=50% height=50% />
</div>

## Miscellaneous

You can change the keybind for switching input method by adding the following into Hyprland config (I use CTRL + SHIFT + F).

```
bind = CTRL_SHIFT, F, exec, fcitx5-remote -t
```
