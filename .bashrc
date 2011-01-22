# Check for an interactive session
[ -z "$PS1" ] && return
PS1='[\u@\h \W]\$ '
#PS1='[\e[1;32m\]\u\e[0m\]@\h \W]\$ '

### sudo shortcuts ###
alias halt='sudo halt'
alias reboot='sudo reboot'
alias exeunt='sudo halt'
alias svim='sudo vim'
alias svi='sudo vim'

alias :q='exit'
alias ls='ls --color=auto'
alias lla='ls -la'
alias lsa='ls -a'

alias vi='vim'
alias qfind='find|grep $1' # quick find

alias grep='grep --color' # always colour grep output

### pacman ###
alias pacman='yaourt'
alias pac='pacman'
alias pacs='pacman -S'
alias pacss='pacman -Ss'
alias pacq='pacman -Q|grep'

### application renaming ###
alias html2pdf='wkhtmltopdf'

### programming ###
alias vgrind='valgrind --leak-check=yes --show-reachable=yes'

### functions ###

# list all processes matching the argument,
# and exclude the grep command
function running() { ps aux | grep $1 | grep -v -P "grep .*$1"; }

function mkcd() { mkdir "$1" && cd "$1"; }

# start, stop, restart, reload - simple daemon management
## usage: start <daemon-name>
## from cinderwick.ca/files/configs/bashrc
start() {
        for arg in $*; do
                sudo /etc/rc.d/$arg start
        done
}
stop() {
        for arg in $*; do
                sudo /etc/rc.d/$arg stop
        done
}
restart() {
        for arg in $*; do
                sudo /etc/rc.d/$arg restart
        done
}
reload() {
        for arg in $*; do
                sudo /etc/rc.d/$arg reload
        done
}

