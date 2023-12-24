# shellcheck shell=bash

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]}]"
fi

function set_path() {
    if [[ -n "${DEBUG:-}" ]]; then
        log debug "[$(basename "${BASH_SOURCE[0]}")]: Resetting \$PATH"
    fi

    local prepend=()
    local append=()
    local gnu_libexec_bins=(
        "coreutils"
        "findutils"
        "gnu-sed"
        "gnu-tar"
        "gnu-which"
        "grep"
        "make"
    )
    local compilers=("llvm/bin")

    if [[ -n ${HOMEBREW_PREFIX} ]]; then
        prepend+=("${HOMEBREW_PREFIX}/lib")                # Homebrew
        prepend+=("${HOMEBREW_PREFIX}/include")            # Homebrew
        prepend+=("${HOMEBREW_PREFIX}/opt")                # Homebrew
        prepend+=("${HOMEBREW_PREFIX}/opt/ncurses/bin")    # Homebrew ncurses
        prepend+=("${HOMEBREW_PREFIX}/opt/gnu-getopt/bin") # GNU get-opt
        prepend+=("${HOME}/.rd/bin")                       # Rancher desktop

        for tool in "${gnu_libexec_bins[@]}"; do
            prepend+=("${HOMEBREW_PREFIX}/opt/${tool}/libexec/gnubin") # Homebrew gnu tools
            prepend+=("${HOMEBREW_PREFIX}/opt/${tool}/libexec/gnubin") # Homebrew gnu tools
        done

        for path in "${compilers[@]}"; do
            prepend+=("${HOMEBREW_PREFIX}/opt/${path}") # llvm
        done

    fi

    prepend+=("/Applications/SnowSQL.app/Contents/MacOS") # SnowSQL

    append+=("${HOME}/.local/bin") # Ansible
    append+=("${HOME}/.cargo/bin") # rust

    add_to_path prepend "${prepend[@]}"
    add_to_path append "${append[@]}"
}

set_path
