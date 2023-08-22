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


function list_dir_cont() {
    local gnu_ls=/usr/local/opt/coreutils/libexec/gnubin/ls
    local lsopts="--color=auto --almost-all"

    if [[ "$1" == "--long" ]]; then
        shift
        lsopts+=" -l --classify --no-group --size --human-readable"
    fi

    if [[ -f ${gnu_ls} ]]; then
        ${gnu_ls} ${lsopts} $@
    else
        printf_error "GNU ls not found at ${gnu_ls}, falling back to /bin/ls"
        /bin/ls ${lsopts} $@
    fi
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
    export PATH="~/.pyenv/bin:${PATH}"            # pyenv
    export PATH="~/.local/bin:${PATH}"            # pipx export PATH="~/go/bin:${PATH}"                # Go binaries
    export PATH="${PATH}:~/.snowsql/1.2.12"       # Snowflake CLI
    export PATH="~/bin:${PATH}"                   # Custom installed binaries
    export PATH="${PATH}:~/.local/bin"            # Ansible:::
    export PATH="${PATH}:~/.cabal/bin/git-repair" # Haskell binaries

    # add homebrew bins and manpages to path
    add_homebrew_tools
}
