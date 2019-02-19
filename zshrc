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
REPORTTIME=1
TIMEFMT="%U user %S system %P cpu %*Es total"

setopt RM_STAR_WAIT  # Prompt for confirmation after globbed rm
setopt NOCLOBBER     # Don't pipe into existing files, need >!
setopt AUTO_CONTINUE # Background processes aren't killed on exit of shell
setopt NO_BG_NICE    # Don't use 'nice' on bg processes

##########################
#       COMPLETION       #
##########################
setopt extendedglob  # Extended globbing, allows regular expressions
setopt nocaseglob    # Case insensitive Globbing
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
# automatically find new executables in path
zstyle ':completion:*' rehash true

#######################
#       HISTORY       #
#######################
HISTFILE=~/.zhistory
HISTSIZE=50000
SAVEHIST=100000
setopt incappendhistory
setopt extendedhistory
setopt hist_ignore_space
setopt hist_reduce_blanks

#######################
#       ALIASES       #
#######################
### sudo ###
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
alias gdb='gdb --silent'
alias grep='grep --color -I'
alias history='history -i'
alias ls='ls --color'
alias mkdir='mkdir -p'
alias stat='stat -sn'
alias tmux='tmux -2'

### command shortening ###
alias :q='exit'
alias cdu='cdup'
alias csc='cscope'
alias emoj='emoji-fzf preview | fzf --preview "emoji-fzf get --name {1}" | cut -d " " -f 1 | emoji-fzf get | xclip'
alias lsa='ls -a'
alias lla='ls -la'
alias lsl='ls -l'
alias fhist='fc -il 1'
alias webserv='python3 -m http.server'
alias env='env | sort'
alias igrep='grep -i'
alias igr='igrep'

### common typos ###
alias gti='git'
alias cd..='cd ../'
alias cud='cdu'
alias find.='find .'

### programming ###
alias vgrind='valgrind --leak-check=yes --show-reachable=yes'

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

#######################
#       PROMPTS       #
#######################
autoload -U colors && colors
# allow functions in the prompt
setopt prompt_subst
[ -f ~/.zsh/completion/_invoke ] && source ~/.zsh/completion/_invoke

#fpath=(/usr/share/bash-completion/completions $fpath)
source ${HOME}/.zsh/functions/git-prompt.sh

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

# Coloured man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Disable CTRL-S pause transmission.
stty -ixon
stty -ixoff

export PATH=${HOME}/.cargo/bin:${PATH}
export PATH=${HOME}/bin:${PATH}
export PATH=/usr/local/bin:${PATH}:/usr/local/opt/go/libexec/bin

gstats() {
    git ls-files -z | xargs -0n1 git blame -w | perl -n -e '/^.*?\((.*?)\s+[\d]{4}/; print $1,"\n"' | sort -f | uniq -c | sort -nr
}

# test for truecolor support of terminal
truecolor() {
  awk 'BEGIN{
      s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
      for (colnum = 0; colnum<77; colnum++) {
          r = 255-(colnum*255/76);
          g = (colnum*510/76);
          b = (colnum*255/76);
          if (g>255) g = 510-g;
          printf "\033[48;2;%d;%d;%dm", r,g,b;
          printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
          printf "%s\033[0m", substr(s,colnum+1,1);
      }
      printf "\n";
  }'
}

# Allow for local zshrc extensions
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
