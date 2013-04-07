cd $HOME

sh ~/.fehbg

if [ -f ~/.xmodmap ]; then
    xmodmap ~/.xmodmap
fi

# set up fonts
xset +fp /usr/share/fonts/local
xset fp rehash

# turn on numlock
which numlockx && numlockx on

# startup conky & dzen bar
(sleep 2 && conky | dzen2 -x 256 -e '' -w 800 -fg '#dcdcdc' -ta l -fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*' -p) &
while [ 1 ]; do date +%c; sleep 1; done | while read -r; do xsetroot -name "$REPLY"; done&

#conky | while read -r; do xsetroot -name "$REPLY"; done &

/home/marc/build/dwm-new/dwm/dwm
