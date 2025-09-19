# sway
## exit
`sway exit`

## list outputs, inputs
`swaymsg -t get_<outputs|inputs>`

## bar
`i3status-rust`
and custom waybar for tray (toggled with switch furthest right in i3status-rust bar)
`waybar -c ~/.config/sway/waytray/config.jsonc -s ~/.config/sway/waytray/style.css`

# daemons
## notifs
`swaync`

## auto tiling
`autotiling-rs`


# utils
## launcher
`tofi-drun`

## configure displays
`nwg-displays`

## screenshots
`grimshot`

## lock
`swaylock`

## clipboard
`wl-copy` and `wl-paste`
aliased to `wlc` and `wlp`

## copy text from screen
`normcap`


# requirements
## pacman
```
sway
sway-contrib
swaync
nwg-displays
autotiling-rs
swaylock
i3status-rust
waybar
```

## aur
```
tofi
```

## pipx
```
normcap
```
