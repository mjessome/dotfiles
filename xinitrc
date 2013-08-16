cd $HOME

# set background
if [ -f ~/.fehbg ]; then
    sh ~/.fehbg
fi
# keymappings
if [ -f ~/.xmodmap ]; then
    xmodmap ~/.xmodmap
fi

# turn on numlock
which numlockx && numlockx on

# startup applications
(sleep 1 && (
    #(xscreensaver -no-splash &) &&
    (urxvtd &) &&
    (xcompmgr &) &&
    (wicd-client -t &)
)) &

# conky output in top bar
conky | while read -r; do xsetroot -name "$REPLY"; done &

exec dwm 2>&1 >> ~/.wm_log
