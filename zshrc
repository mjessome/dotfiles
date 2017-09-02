[ -z "$PROMPT" ] && return

export EDITOR='vim'

unsetopt beep # turn of system beep

# remove the need for ""s around urls in commands.
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

autoload -Uz compinit
compinit
zmodload zsh/stat
zstyle :compinstall filename '/home/marc/.zshrc'

# instead of xargs, zargs
# example: zargs **/* -- grep "match this"
autoload -U zargs

# report how long a command took above certain run time
REPORTTIME=5
TIMEFMT="%U user %S system %P cpu %*Es total"

# Prompt for confirmation after globbed rm
# eg. 'rm *' or 'rm *.c'
setopt RM_STAR_WAIT
# dont pipe into existing files, need >!
setopt NOCLOBBER
# Background processes aren't killed on exit of shell
setopt AUTO_CONTINUE
# don't use 'nice' on bg processes
setopt NO_BG_NICE
# watch user logins/outs
watch=notme
LOGCHECK=60

##########################
#       COMPLETION       #
##########################
# case insensitive globbing
setopt extendedglob
unsetopt caseglob
# Write globbed files out
autoload insert-files
zle -N insert-files
bindkey '^Xf' insert-files
# renaming with globbing
autoload zmv
# select by menu for kill command
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# remove trailing / on directories
zstyle ':completion:*' squeeze-slashes true
# Colours on completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
setopt correct
# case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

#######################
#       HISTORY       #
#######################
HISTFILE=~/.zhistory
HISTSIZE=100000
SAVEHIST=50000
setopt incappendhistory
setopt extendedhistory
setopt hist_ignore_space
setopt hist_reduce_blanks

#######################
#       ALIASES       #
#######################
### sudo shortcuts ###
alias halt='sudo halt'
alias reboot='sudo reboot'
alias svim='sudo vim'
alias svi='sudo vim'

### pacman ###
alias pac='pacman'
alias pacs='pacman -S'
alias pacss='pacman -Ss'
alias pacq='pacman -Q|grep'
alias yrt='yaourt'
alias yrts'yrt -S'
alias yrtss='yrt -Ss'
alias yrtq='yrt -Q|grep'

### aptitude ###
alias apt='aptitude'

### suffixes ###
alias -s c='${EDITOR}'
alias -s cpp='${EDITOR}'
alias -s cc='${EDITOR}'
alias -s h='${EDITOR}'
alias -s txt='${EDITOR}'
alias -s rc='${EDITOR}'
alias -s md='$(EDITOR)'
alias -s pdf='zathura'

### default options ###
alias df='df -h'
alias grep='grep --color -I'
alias history='history -i'
alias ls='ls -G'
alias mkdir='mkdir -p'
alias stat='stat -sn'
alias tmux='tmux -2'

### command shortening ###
alias :q='exit'
alias ,e='vim'
alias :e='vim'
alias cdu='cdup'
alias cls='clear'
alias csc='cscope'
alias cscd='csc -d'
alias lsa='ls -a'
alias lla='ls -la'
alias lsl='ls -l'
alias szsh='source ~/.zshrc'
alias fhist='fc -il 1'
alias atclr='atq | awk "{print \$1}" | xargs atrm'
alias webserv='python -m SimpleHTTPServer'
alias env='env | sort'
alias bgd='bg && disown'
alias igrep='grep -i'
alias igr='igrep'
alias vgrep='grep -v'
alias vgr='vgrep'
alias ivgrep='grep -iv'
alias vigrep='ivgrep'
alias ncm='ncmpcpp'

### common typos ###
alias gti='git'
alias cd..='cd ../'
alias cud='cdu'
alias find.='find .'

### programming ###
alias vgrind='valgrind --leak-check=yes --show-reachable=yes'
#alias gdb='gdb -silent'

### global aliases ###
alias -g G='| grep'
alias -g X='| xargs'
alias -g XG='| xargs grep'
alias -g ...='../../'
alias -g ....='../../../'
alias -g .....='../../../..'
alias -g V='| vim -'
alias -g VIM='| vim -'

#### ignore in history ###
alias fg=' fg'

#########################
#       FUNCTIONS       #
#########################
# list all process matching the arg, exclude the grep cmd
function running() {
    ps aux | grep $1 | grep -v -P "grep.*$1";
}
#generate a spectrogram of the specified file
function spectra() {
    F=/tmp/spectra.${RANDOM}.png
    sox "$1" -n spectrogram -o "$F"
    RC=$?
    if [ $RC -eq 0 ]; then
        echo "Spectrogram output to $F"
        feh $F
    fi
    return $RC
}
function mkcd() {
    if [[ ! -d "$1" ]]; then
        mkdir -p "$1" && cd "$1"
    else
        cd "$1"
    fi
}
function hist_most() {
    fhist | awk '{print $4}' | sort | uniq -c | sort -rn | head -${1:=10}
}
function cl() {
    cd $1 && ls
}
function cpln() {
    head -n $1 $2 | tail -n 1 | xclip
}
function define() {
    curl dict://dict.org/d:$1
}
function hl() {
    # hilight the given word
    hlstr=""
    for arg in $@; do
        hlstr+="$arg\|"
    done
    grep --color=always -i $hlstr
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
# When directory is changed set xterm title to host:dir
chpwd() {
    [[ -t 1 ]] || return
    case $TERM in
        sun-cmd) print -Pn "\e]l%~\e\\";;
        *xterm*|*rxvt*|(dt|k|E)term) print -Pn "\e]2;%m: %~\a";;
    esac
}

#######################
#       PROMPTS       #
#######################
autoload -U colors && colors
# allow functions in the prompt
setopt PROMPT_SUBST
source ~/.zsh/completion/_invoke

fpath=(/usr/local/etc/bash_completion.d/* $fpath)
source /usr/local/etc/bash_completion.d/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM="verbose"
# colour username blue for zsh, hostname green, vc_info
# on successful command, green "$", otherwise red "[rc] $"
PROMPT=$'%(1j.[%{$fg_bold[blue]%}%j%{$reset_color%}].)[%*][%{$fg_bold[yellow]%}%n%{$reset_color%} %~%{$fg_bold[green]%}$(__git_ps1 " (%s)")%{$reset_color%}]
%(?.%{$fg_bold[green]%}.%{$fg_bold[red]%}[%?] )$%{$reset_color%} '

###########################
#       KEYBINDINGS       #
###########################
export KEYTIMEOUT=1 # get rid of delay after pressing <ESC> to enter vi mode.

bindkey -v  # use vim insert keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey '^?' backward-delete-char
bindkey "\e[1~" beginning-of-line # Home for xterm
bindkey "\e[4~" end-of-line # End for rxvt
bindkey "\e[7~" beginning-of-line # Home for rxvt
bindkey "\e[8~" end-of-line # End for rxvt
bindkey "\eOH" beginning-of-line # Home for non-RH xterm
bindkey "\eOF" end-of-line # End for non-RH xterm
bindkey "\e[H" beginning-of-line # Home for freebsd console
bindkey "\e[F" end-of-line # End for freebsd console
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "\e[2~" quoted-insert # Ins
bindkey "\e[3~" delete-char # Del
bindkey "\e[5C" forward-word
bindkey "\e[5D" backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[Z" reverse-menu-complete # Shift+Tab
# Only past commands matching current input are searched
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey "^R" history-incremental-search-backward

# Change cursor to red when in command mode
zle-keymap-select () {
    if [ $TERM = "linux" ]; then
        return;
    fi
    if [ $KEYMAP = vicmd ]; then
        echo -ne "\033]12;Red\007"
    else
        echo -ne "\033]12;Grey\007"
    fi
}
zle -N zle-keymap-select
zle-line-init () {
    if [ $TERM = "linux" ]; then
        return
    fi
    zle -K viins
    echo -ne "\033]12;Grey\007"
}
zle -N zle-line-init

# man page colours
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

if [ $TERM != "linux" ]; then
  export TERM=screen-256color
fi

# Disable CTRL-S pause transmission.
stty -ixon
stty -ixoff

# virtualenv
export WORKON_HOME=$HOME/.virtualenvs
source $(which virtualenvwrapper.sh)

# virtualenv aliases
# http://blog.doughellmann.com/2010/01/virtualenvwrapper-tips-and-tricks.html
alias v='workon'
alias v.deactivate='deactivate'
alias v.mk='mkvirtualenv --no-site-packages'
alias v.mk_withsitepackages='mkvirtualenv'
alias v.rm='rmvirtualenv'
alias v.switch='workon'
alias v.add2virtualenv='add2virtualenv'
alias v.cdsitepackages='cdsitepackages'
alias v.cd='cdvirtualenv'
alias v.lssitepackages='lssitepackages'

[ -f ~/.zsh.secret ] && source ~/.zsh.secret
[ -f ~/.zsh/fitbit ] && source ~/.zsh/fitbit

export PATH=${HOME}/.cargo/bin:${PATH}
export PATH=${HOME}/bin:${PATH}
export PATH=/usr/local/bin:${PATH}:/usr/local/opt/go/libexec/bin

gstats() {
    git ls-files -z | xargs -0n1 git blame -w | perl -n -e '/^.*?\((.*?)\s+[\d]{4}/; print $1,"\n"' | sort -f | uniq -c | sort -nr
}
