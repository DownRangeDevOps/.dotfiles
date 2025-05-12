# shellcheck shell=bash

# Initialize ZLE and completion system early
zmodload zsh/zle
autoload -Uz compinit
compinit -C -d "${HOME}/.zcompdump"
autoload -Uz compdef
function zle-keymap-select() { zle reset-prompt }
zle -N zle-keymap-select

<<<<<<< HEAD
alias assume=". assume"
=======
alias assume="source assume"
>>>>>>> 9e03a31 (* Fix `.fdignore` format)
