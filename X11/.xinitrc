xrdb -merge $HOME/.config/X11/.Xresources
urxvtd -o -q -f
setxkbmap -option caps:escape
setxkbmap -option 'caps:ctrl_modifier';xcape -e 'Caps_Lock=Escape'&
udiskie &
exec i3
