[ -z "$PS1" ] && return

export EDITOR='vim'

unsetopt beep # turn of system beep
bindkey -v  # use vim keybindings

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

#######################
#       HISTORY       #
#######################
HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000
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

### suffixes ###
alias -s c='${EDITOR}'
alias -s cpp='${EDITOR}'
alias -s cc='${EDITOR}'
alias -s h='${EDITOR}'
alias -s txt='${EDITOR}'
alias -s rc='${EDITOR}'
alias -s pdf='zathura'

### default options ###
alias ls='ls --color'
alias history='history -i'
alias df='df -h'
alias mkdir='mkdir -p'
alias stat='stat -sn'

### command shortening ###
alias lsa='ls -a'
alias lla='ls -la'
alias lsl='ls -l'
alias :q='exit'
alias grep='grep --color'
alias szsh='source ~/.zshrc'

### common typos ###
alias gti='git'
alias cd..='cd ../'

### application renaming ###
alias html2pdf='wkhtmltopdf'
alias vdiff='vimdiff'
alias vi='vim'

### programming ###
alias vgrind='valgrind --leak-check=yes --show-reachable=yes'
alias gdb='gdb -silent'

### global aliases ###
alias -g G='| grep'
alias -g X='| xargs'
alias -g XG='| xargs grep'
alias -g ...='../../'
alias -g ....='../../../'
alias -g .....='../../../..'

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
    mkdir "$1" && cd "$1"
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
fpath+=~/.zsh/functions
autoload -U ~/.zsh/functions/*(:t)
# colour username blue, hostname green, vc_info
# on successful command, green "$", otherwise red "[rc] $"
PROMPT=$'[%{$fg_bold[blue]%}%n%{$reset_color%}@%{$fg_bold[green]%}%m%{$reset_color%} %1d$(git_info)%{$reset_color%}]
%(?.%{$fg_bold[green]%}.%{$fg_bold[red]%}[%?] )$%{$reset_color%} '

###########################
#       KEYBINDINGS       #
###########################
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

