# bash.sh
log debug ""
log debug "$(printf_callout ["${BASH_SOURCE[0]}"])"

# overwrites PS1 so do it first
source /usr/local/share/google-cloud-sdk/path.bash.inc

# bash completions
if [[ -r /usr/local/etc/bash_completion ]]; then
    set +u
    source /usr/local/etc/bash_completion
fi

# ------------------------------------------------
#  helpers
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

# Don't expand paths
_expand() { return 0; }

function ls() {
  /bin/ls -GhA "$@"
}

function ll() {
  /bin/ls -GFlash "$@"
}

function add_homebrew_tools() {
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Adding homebrew paths..."

    local gnu_tools
    local compilers

    mapfile -t gnu_tools <<-EOT
        gnu-tar
        gnu-which
        gnu-sed
        grep
        coreutils
        findutils
        make
EOT

    mapfile -t compilers <<-EOT
        /usr/local/opt/llvm/bin
EOT

    for tool in "${gnu_tools[@]}"; do
        tool=$(printf "%s" "${tool}" | trim)
        export PATH="/usr/local/opt/${tool}/libexec/gnubin:${PATH}" # Homebrew gnu tools
        export PATH="/usr/local/opt/${tool}/libexec/gnuman:${PATH}" # Homebrew gnu manpages
    done

    for path in "${compilers[@]}"; do
        tool=$(printf "%s" "${path}" | trim)
        export PATH="${path}:${PATH}"
    done
}

function set_path() {
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Setting path..."

    export PATH=""                      # Reset
    source /etc/profile                 # Base

    # Add to path
    export PATH="/opt/X11/bin:${PATH}"
    export PATH="/usr/local/sbin:${PATH}"               # Homebrew bin path
    export PATH="/usr/local/opt/ruby/bin:${PATH}"       # Homebrew Ruby
    export PATH="${HOME}/.pyenv/bin:${PATH}"            # pyenv
    export PATH="${HOME}/.local/bin:${PATH}"            # pipx export PATH="${HOME}/go/bin:${PATH}"                # Go binaries
    export PATH="${PATH}:${HOME}/.snowsql/1.2.12"       # Snowflake CLI
    export PATH="${HOME}/bin:${PATH}"                   # Custom installed binaries
    export PATH="${PATH}:${HOME}/.local/bin"            # Ansible:::
    export PATH="${PATH}:${HOME}/.cabal/bin/git-repair" # Haskell binaries

    # add homebrew bins and manpages to path
    add_homebrew_tools
}
