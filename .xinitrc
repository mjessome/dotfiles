
export EDITOR=/usr/bin/vim

sh ~/.fehbg

conky
while [ 1 ]; do date +%c; sleep 1; done | while read -r; do xsetroot -name "$REPLY"; done &
exec ~/build/dwm/dwm
