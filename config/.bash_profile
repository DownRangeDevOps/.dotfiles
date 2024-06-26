# shellcheck shell=bash disable=SC1090,SC1091  # ignore refusal to follow dynamic paths
# Load .bashrc
if [[ -n "${ZSH_VERSION:-}" ]]; then
    if [[ -f "${HOME}/.zshrc" ]]; then
        if [[ -n "${DEBUG:-}" ]]; then
            log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Loading .zshrc..."
        fi

        source "${HOME}/.zshrc"

        if [[ -n "${DEBUG:-}" ]]; then
            log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Done."
        fi
    fi
else
    if [[ -f "${HOME}/.bashrc" ]]; then
        if [[ -n "${DEBUG:-}" ]]; then
            log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Loading .bashrc..."
        fi

        source "${HOME}/.bashrc"

        if [[ -n "${DEBUG:-}" ]]; then
            log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Done."
        fi
    fi
fi


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
if [[ -d "/Users/${PERSONAL_LAPTOP_USER}" ]]; then source ~/.bash_secrets; fi

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

# Source .bashrc
if [[ -n "${ZSH_VERSION:-}" && -f "${HOME}/.zshrc" ]]; then
    safe_source "${HOME}/.zshrc"
elif [[ -f "${HOME}/.bashrc" ]]; then
    safe_source "${HOME}/.bashrc"
fi

safe_source "${BASH_D_PATH}/path.sh"
safe_source "${BASH_D_PATH}/bash.sh"
safe_source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"

# Disable strictness
set +uao pipefail

log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Done, .bash_profile loaded."

# vi: ft=zsh
