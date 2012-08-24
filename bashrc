# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Check for an interactive session
[ -z "$PS1" ] && return
PS1='[\u@\e[1;33m\]\h\e[0m\] \W]\$ '
if [ -r /etc/bash_completion ]; then
    source /etc/bash_completion.d/git-completion.bash
    PS1='[\u@\e[1;32m\]\h\e[0m\] \W$(__git_ps1 " \e[1;35m\](%s)\e[0m\]")]\]\n$ '
fi


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
alias df='df -h'

alias vi='vim'
alias qfind='find|grep -i $1' # quick find

alias grep='grep --color' # always colour grep output

alias wpa='sudo wpa_supplicant -iwlan0 -c/etc/wpa_supplicant.conf'

### pacman ###
#alias pacman='yaourt'
alias pac='pacman'
alias pacs='pacman -S'
alias pacss='pacman -Ss'
alias pacq='pacman -Q|grep'

### application renaming ###
alias html2pdf='wkhtmltopdf'
alias vdiff='vimdiff'
alias gti='git'

### programming ###
alias vgrind='valgrind --leak-check=yes --show-reachable=yes'
alias gdb='gdb -silent'

### functions ###

# list all processes matching the argument,
# and exclude the grep command
function running() {
    ps aux | grep $1 | grep -v -P "grep .*$1";
}

# generate a spectrogram of the specified file.
function spectra() {
    F=/tmp/spectra.${RANDOM}.png;
    sox "$1" -n spectrogram -o "$F";
    RC=$?
    if [ $RC -eq 0 ]; then
        echo "Spectrogram output to $F"
        feh "$F"
    fi
    return $RC
}

function mkcd() {
    mkdir "$1" && cd "$1";
}

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

# man page colours
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

