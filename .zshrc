setopt interactivecomments
setopt magicequalsubst
setopt nonomatch
setopt notify
setopt numericglobsort
setopt promptsubst
unsetopt beep

WORDCHARD=${WORDCHARS//\/}
export PROMPT_EOL_MARK=""
bindkey -e

autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' mather-list 'm:{a-zA-Z}={A-Za-z}'

HISTFILE=~/.zsh_history
HISTSIZE=4096
SAVEHIST=4096
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats "─(%F{11}%b%f)"
#zstyle ':vcs_info:*' actionformats \
#'%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
#zstyle ':vcs_info:*' formats \
#'%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
#zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

precmd() {
    if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
        _NEW_LINE_BEFORE_PROMPT=1
    else
        print ""
    fi
    vcs_info
}
_NEWLINE=$'\n'
PROMPT='┌─(%B%(!.%F{red}.%F{blue})%n@%m%f%b)─(%B%~%b)${vcs_info_msg_0_}${_NEWLINE}└─%B%(!.%F{red}#.%F{blue}$)%f%b '
#PROMPT=$'┌─(%B%(!.%F{red}.%F{blue})%n@%m%F{reset}%b)─(%B%F{white}%~%F{reset}%b)${vcs_info_msg_0_}%F{reset}${\n└─%B%(!.%F{red}#.%F{blue}$%F{reset}%b) ' 
#RPROMPT=

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
export LESS=-R
export LESS_TERMCAP_MB=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

# rbenv
#eval "$(rbenv init -)"

TERM=xterm-256color

# support local (machine-specific) config
if [ -f ~/.zshrc.local ]; then
	source ~/.zshrc.local
fi

