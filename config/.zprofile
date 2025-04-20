# shellcheck shell=bash disable=SC1090,SC1091  # ignore refusal to follow dynamic paths
# .zprofile

# Uncomment to use the profiling module (`zprof`)
# zmodload zsh/zprof

# Reset path to always start fresh
export PATH=""

set +ua
# Set default paths
if [[ -n "${ZSH_VERSION:-}" ]]; then
    source /etc/zprofile
else
    source /etc/profile
fi
set -ua

# Set base Homebrew paths
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Source Homebrew GitHub token
if [[ -n "${PERSONAL_LAPTOP_USER:-}" && -d "/Users/${PERSONAL_LAPTOP_USER}" ]]; then source ~/.bash_secrets; fi

# Globals
export DOTFILES_PREFIX="${HOME}/.dotfiles"
export BASH_D_PATH="${DOTFILES_PREFIX}/bash.d"
export PATH="${DOTFILES_PREFIX}/bin:${PATH}" # my bins

# Load logger or overload with no-op
if [[ ${DEBUG:-} -eq 1 ]]; then

    # We need to use `basename` from Homebrew for `log.sh`
    function basename() {
        "${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin/basename" "$@"
    }

    set +ua
    [[ -f "${HOME}/.dotfiles/lib/log.sh" ]] && "${HOME}/.dotfiles/lib/log.sh"
    set -ua
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

# -a: Export all functions to make them available in sub-shells
# -u: We should not use unbound variables
# -o pipefile: We should ensure pipelines fail if commands within them fail
#
# WARNING: Unset with +a and +u before sourcing third party libraries or they
# will export functions and throw errors
set -uao pipefail

# Disable flow control commands (keeps C-s from freezing everything)
stty -ixon 2>/dev/null

# Load everything else
log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Loading helpers..."

[[ -f "${BASH_D_PATH}/lib.sh" ]] && source "${BASH_D_PATH}/lib.sh"

safe_source "${BASH_D_PATH}/path.sh"
safe_source "${BASH_D_PATH}/bash.sh"

# ------------------------------------------------
# Set up Homebrew ZSH completions
# ------------------------------------------------
if type brew &>/dev/null; then
    # Add Homebrew's completions to FPATH
    FPATH="$(brew --prefix)/share/zsh-completions:${FPATH}"
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

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

# Disable strictness
set +uao pipefail


# ------------------------------------------------
#  Set up direnv shell hook
# ------------------------------------------------
set +ua
if [[ -n "$(command -v direnv)" ]]; then
    eval "$("${HOMEBREW_PREFIX}/bin/direnv" hook zsh)"
else
    print_warnining 'direnv does not seem to be installed (`brew install direnv`)'
fi
set -ua

# ------------------------------------------------
# Enable ASDF
# ------------------------------------------------
if [[ -n "$(command -v asdf)" ]]; then
    "${HOMEBREW_PREFIX}/opt/asdf/libexec/asdf.sh"
    ASDF_PYAPP_DEFAULT_PYTHON_PATH="${HOME}/.asdf/shims/python"
else
    printf_warning 'ASDF does not seem to be installed: `brew install asdf`'
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

log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Done, .bash_profile loaded."

# Unset strict options, we only care about our code
set +ua

# vim: ft=zsh
