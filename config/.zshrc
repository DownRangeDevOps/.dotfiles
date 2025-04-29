# shellcheck shell=bash

# Disable flow control commands (keeps C-s from freezing everything)
stty -ixon 2>/dev/null

# Only source zprofile if this is not a login shell and the file exists
if [[ -z "$ZSH_PROFILE_SOURCED:-" ]] && [[ $- != *l* ]] && [[ -f "${HOME}/.zprofile" ]]; then
    export ZSH_PROFILE_SOURCED=1
    source "${HOME}/.zprofile"
fi

# Source `.zprofile` if it exists and we're in NeoVim
if [[ -n "$NVIM:-" ]]; then
    if [[ -z "$ZSH_PROFILE_SOURCED:-" ]] && [[ -f "${HOME}/.zprofile" ]]; then
        export ZSH_PROFILE_SOURCED=1
        source "${HOME}/.zprofile"
    fi
fi

# Load logger or overload with no-op
if [[ ${DEBUG:-} -eq 1 ]]; then

    # We need to use `basename` from Homebrew for `log.sh`
    function basename() {
        "${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin/basename" "$@"
    }

    [[ -f "${HOME}/.dotfiles/lib/log.sh" ]] && "${HOME}/.dotfiles/lib/log.sh"

    log debug ""
    log debug "[${BASH_SOURCE[0]:-${(%):-%x}}]"
else
    log_sh_args=("info" "warn" "error" "debug")
    function log() {
        if [[ "${log_sh_args[*]}" =~ ${1:-} ]]; then
            true
        else
            log "$@"
        fi
    }
fi

# ------------------------------------------------
#  vale
# ------------------------------------------------
export VALE_CONFIG_PATH="${HOME}/.dotfiles/config/vale/.vale.ini"

# ------------------------------------------------
# Interactive terminal configuration
# ------------------------------------------------

# History
export HISTSIZE=500000
export HISTFILESIZE=500000

if [[ -n "${ZSH_VERSION:-}" ]]; then
    setopt SHARE_HISTORY            # import old commands, append new, so all sessions have the same hist
    setopt HIST_IGNORE_ALL_DUPS     # do not put duplicated command into history list
    setopt HIST_SAVE_NO_DUPS        # omit older duplicates
    setopt HIST_REDUCE_BLANKS       # remove unnecessary blanks
else
    export HISTCONTROL=ignoreboth:erasedups # don't put duplicate lines in the history
    shopt -s histappend   # append
    shopt -s checkwinsize # check the win size after each command and update if necessary
    history -a            # append
    history -n            # read new lines and append
fi

if [[ -z "${ZSH_VERSION:-}" ]]; then
    # Search history with arrows, up: \e[A, down: \e[B
    # bind '"\e[A": history-search-backward'
    # bind '"\e[B": history-search-forward'
    for direction (up down) {
        autoload "${direction}-line-or-beginning-search"
        zle -N "${direction}-line-or-beginning-search"
        key="${terminfo}[kcu${direction}[1]1]"

        for key ("${key}" "${key/O/[}")
            bindkey "${key}" "${direction}-line-or-beginning-search"
    }

    if ((original_buffer_length == 0)); then
        CURSOR=$#BUFFER
    fi
fi

# Source Homebrew GitHub token
if [[ -n "${PERSONAL_LAPTOP_USER:-}" && -d "/Users/${PERSONAL_LAPTOP_USER}" ]]; then
    if [[ -f "${HOME}/.secrets" ]]; then
        source "${HOME}/.secrets"
    fi
fi

# Disable strictness, below here is all external code
set +ua

# ------------------------------------------------
# Source dependencies
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Loading helpers..."

[[ -f "${BASH_D_PATH}/lib.sh" ]] && source "${BASH_D_PATH}/lib.sh"
safe_source "${BASH_D_PATH}/path.sh"
safe_source "${BASH_D_PATH}/bash.sh"
safe_source "${CONFIG_FILES_PREFIX}/.zaliases"

# ------------------------------------------------
# Set base Homebrew paths
# ------------------------------------------------
if [[ -n "$(command -v brew)" ]]; then
    if [[ $(uname -m) == "arm64" ]]; then
        # Source brew shellenv but with safer FPATH handling
        BREW_OUTPUT=$(/opt/homebrew/bin/brew shellenv | grep -v "fpath")
        eval "$BREW_OUTPUT"

        # Add Homebrew completions to FPATH manually
        FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
    else
        # Source brew shellenv but with safer FPATH handling
        BREW_OUTPUT=$(/usr/local/bin/brew shellenv | grep -v "fpath")
        eval "$BREW_OUTPUT"

        # Add Homebrew completions to FPATH manually
        FPATH="/usr/local/share/zsh/site-functions:$FPATH"
    fi

    # Builtin docs: https://linux.die.net/man/1/zshbuiltins
    # -U: Load the function without aliasing
    # -z: Only load `zsh` functions
    # -C: Skip security checks

    # Only initialize completions if not already initialized
    # This avoids double initialization
    if [[ -n "${ZSH_VERSION:-}" ]]; then
        # Load and initialize Zsh completion system once
        autoload -Uz compinit
        compinit -C -d "${HOME}/.zcompdump"

        # Make compdef available
        autoload -Uz compdef

        # Set up caching for completions
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path ~/.zsh/cache
    fi
fi

# ------------------------------------------------
# Load antidote
# ------------------------------------------------
export ANTIDOTE_HOME="${HOME}/.cache/antidote"

# shellcheck disable=SC1091
if [[ -n "${ZSH_VERSION:-}" && -f "${HOMEBREW_PREFIX}/opt/antidote/share/antidote/antidote.zsh" ]]; then
    # Load antidote directly rather than using autoload
    source "${HOMEBREW_PREFIX}/opt/antidote/share/antidote/antidote.zsh"

    # Set the root name of the plugins files (.txt and .zsh) antidote will use.
    zsh_plugins="${HOME}/.zsh_plugins"

    # Create a new plugins file if it doesn't exist.
    if [[ ! -f "${zsh_plugins}.txt" ]]; then
        touch "${zsh_plugins}.txt"
    fi

    # Generate a new static file whenever .zsh_plugins.txt is updated.
    if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
        antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
    fi

    # Source your static plugins file.
    source ${zsh_plugins}.zsh
fi

# ------------------------------------------------
# Use Starship for my shell prompt
# ------------------------------------------------
if [[ -n "$(command -v starship)" ]]; then
    if [[ -n "${ZSH_VERSION:-}" ]]; then
        eval "$("${HOMEBREW_PREFIX}/bin/starship" init zsh)"
    else
        eval "$("${HOMEBREW_PREFIX}/bin/starship" init bash)"
    fi
else
    printf_warning 'Starship does not seem to be installed: `brew install starship`'
fi

# vim: ft=zsh
