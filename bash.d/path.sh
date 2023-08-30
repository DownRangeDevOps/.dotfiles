log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# Reset PATH then add bins
function set_path() {
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Resetting PATH"

    local gnu_tools=("gnu-tar" "gnu-which" "gnu-sed" "grep" "coreutils" "findutils" "make")
    local compilers=("llvm/bin")

    export PATH=""      # Reset
    source /etc/profile # Base

    if [[ -n ${BREW_PREFIX} ]]; then
        add_to_path "prepend" "${BREW_PREFIX}/bin"     # Homebrew
        add_to_path "prepend" "${BREW_PREFIX}/lib"     # Homebrew
        add_to_path "prepend" "${BREW_PREFIX}/include" # Homebrew
        add_to_path "prepend" "${BREW_PREFIX}/opt"     # Homebrew
        add_to_path "prepend" "${BREW_PREFIX}/sbin"    # Homebrew

        for tool in "${gnu_tools[@]}"; do
            add_to_path "prepend" "${BREW_PREFIX}/opt/${tool}/libexec/gnubin" # Homebrew gnu tools
            add_to_path prepend "${BREW_PREFIX}/opt/${tool}/libexec/gnubin" # Homebrew gnu tools
        done

        for path in "${compilers[@]}"; do
            add_to_path prepend "${BREW_PREFIX}/opt/${path}" # llvm
        done
    fi

    add_to_path "prepend" "/opt/X11/bin"       # X11
    add_to_path "append" "${HOME}/.local/bin"  # Ansible
    add_to_path "append" "${HOME}/.cabal/bin/" # Haskell
}
set_path
