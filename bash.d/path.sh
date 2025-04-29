# shellcheck shell=bash disable=SC1091

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [$0]"
fi

function set_path() {
    if [[ -n "${DEBUG:-}" ]]; then
        log debug "[$(basename "$0")]: Resetting \$PATH"
    fi

    local tool
    local compiler
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
        prepend+=("${HOME}/.asdf/shims")
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

        for compiler in "${compilers[@]}"; do
            prepend+=("${HOMEBREW_PREFIX}/opt/${compiler}") # llvm
        done

    fi

    append+=("${HOME}/.local/bin")   # Ansible
    append+=("${HOME}/.cargo/bin")   # rust

    if [[ -n "${PERSONAL_LAPTOP_USER:-}" && -d "/Users/${PERSONAL_LAPTOP_USER}" ]]; then append+=("/usr/local/mysql/bin"); fi # mysql

    # Reverse the arrays so they're added to `$PATH` in the priority they are arranged here
    # Note: zsh only, but I'm no longer using bash as my shell

    prepend=("${(Oa@)prepend}")
    append=("${(Oa@)append}")

    add_to_path prepend "${prepend[@]}"
    add_to_path append "${append[@]}"
}

set_path
