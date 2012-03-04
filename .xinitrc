cd $HOME
export EDITOR=/usr/bin/vim
export WM=/usr/local/bin/dwm

sh ~/.fehbg

if [ -f ~/.xmodmap ]; then
    xmodmap ~/.xmodmap
fi

conky
while [ 1 ]; do date +%c; sleep 1; done | while read -r; do xsetroot -name "$REPLY"; done &
wm-start
