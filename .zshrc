[ -z "$PS1" ] && return

# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=5000
unsetopt beep
# use vim keybindings
bindkey -v

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/marc/.zshrc'

autoload -Uz compinit compinit
# End of lines added by compinstall

# save timestamp with history
setopt extendedhistory

# case insensitive globbing
setopt extendedglob
unsetopt CASE_GLOB

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
alias -s c='vim'
alias -s cpp='vim'
alias -s cc='vim'
alias -s h='vim'
alias -s txt='vim'
alias -s rc='vim'

### default options ###
alias ls='ls --color'
alias history='history -i'
alias df='df -h'

### command shortening ###
alias lsa='ls -a'
alias lla='ls -la'
alias lsl='ls -l'
alias :q='exit'
alias grep='grep --color'

### application renaming ###
alias html2pdf='wkhtmltopdf'
alias vdiff='vimdiff'
alias gti='git'
alias vi='vim'

### programming ###
alias vgrind='valgrind --leak-check=yes --show-reachable=yes'
alias gdb='gdb -silent'

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

#######################
#       PROMPTS       #
#######################
autoload -U colors && colors

# VCS info. Supports git, hg, cvs, svn
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' disable bzr cdv darcs mtn svk tla
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg_bold[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}

# colour username blue for zsh, hostname green, vc_info
# on successful command, green "$", otherwise red "[rc] $"
export PS1="[%{$fg_bold[blue]%}%n%{$reset_color%}@%{$fg_bold[green]%}%m\
%{$reset_color%} %1d] $(vcs_info_wrapper)
%(?.%{$fg_bold[green]%}.%{$fg_bold[red]%}[%?] )$%{$reset_color%} "

###########################
#       KEYBINDINGS       #
###########################
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

