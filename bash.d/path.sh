# shellcheck shell=bash

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]}]"
fi

# Reset PATH then add bins
function set_path() {
    if [[ -n "${DEBUG:-}" ]]; then
        log debug "[$(basename "${BASH_SOURCE[0]}")]: Resetting \$PATH"
    fi

    local prepend
    local append
    local gnu_tools=("gnu-tar" "gnu-which" "gnu-sed" "grep" "coreutils" "findutils" "make")
    local compilers=("llvm/bin")

    export PATH="" # Reset

    set +ua
    source /etc/profile # Base
    set -ua

    # Make personal bins available first in case anything else uses them
    prepend="${HOME}/.dotfiles/bin"

    if [[ -n ${BREW_PREFIX} ]]; then
        prepend+=":${BREW_PREFIX}/bin"     # Homebrew
        prepend+=":${BREW_PREFIX}/lib"     # Homebrew
        prepend+=":${BREW_PREFIX}/include" # Homebrew
        prepend+=":${BREW_PREFIX}/opt"     # Homebrew
        prepend+=":${BREW_PREFIX}/sbin"    # Homebrew

        for tool in "${gnu_tools[@]}"; do
            prepend+=":${BREW_PREFIX}/opt/${tool}/libexec/gnubin" # Homebrew gnu tools
            prepend+=":${BREW_PREFIX}/opt/${tool}/libexec/gnubin" # Homebrew gnu tools
        done

        for path in "${compilers[@]}"; do
            prepend+=":${BREW_PREFIX}/opt/${path}" # llvm
        done
    fi

    prepend+=/Applications/SnowSQL.app/Contents/MacOS:$PATH # SnowSQL

    append="${HOME}/.local/bin"   # Ansible
    append+=":${HOME}/.cargo/bin" # rust

    add_to_path prepend "${prepend}"
    add_to_path append "${append}"
}

set_path
