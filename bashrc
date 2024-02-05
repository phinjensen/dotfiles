#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ ' # fallback if Starship doesn't load

source ~/.config/user-dirs.dirs

alias ls='ls --color=auto'
alias vim='lvim'

export PATH="$PATH:$HOME/.cargo/bin"

eval "$(starship init bash)"
