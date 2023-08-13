# vim: set ft=bash:
# bash.sh

# create the logger before anything else
function logger() {
    if [[ ${DEBUG} == "true" ]]; then
        printf  "%s\n" "$@"
    fi
}

logger "" "[${BASH_SOURCE[0]}]"

# Source gcloud files first so PS1 gets overridden
source "/usr/local/share/google-cloud-sdk/path.bash.inc"

# ------------------------------------------------
#  helpers
# ------------------------------------------------
logger "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

# Don't expand paths
_expand() { return 0; }

function prompt_to_continue() {
    read -p "${*:-Continue?} (y)[es|no] " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        printf "\n\n"
    else
        printf "%s\n" "Ok, exiting."
        return 1
    fi
}

function join() {
    local IFS=$1
    __="${*:2}"
}

function ls() {
  /bin/ls -GhA "$@"
}

function ll() {
  /bin/ls -GFlash "$@"
}

function add_homebrew_tools_and_docs_to_path() {
    logger "[$(basename "${BASH_SOURCE[0]}")]: Adding homebrew paths..."

    local tools
    local default_tools

    mapfile -t tools <<< "${@}"
    mapfile -t default_tools <<-EOF
        gnu-tar
        gnu-which
        gnu-sed
        grep
        coreutils
        findutils
        make
EOF

    if [[ -n "${tools[*]}" ]]; then
        tools="${default_tools[*]}"
    fi

    for tool in ${tools}; do
        export PATH="/usr/local/opt/${tool}/libexec/gnubin:${PATH}" # Homebrew gnu tools
        export PATH="/usr/local/opt/${tool}/libexec/gnuman:${PATH}" # Homebrew gnu manpages
    done
}

function set_path() {
    logger "[$(basename "${BASH_SOURCE[0]}")]: Setting path..."

    export PATH=""                      # Reset
    source /etc/profile                 # Base

    # Add to path
    export PATH="/opt/X11/bin:${PATH}"
    export PATH="/usr/local/sbin:${PATH}"               # Homebrew bin path
    export PATH="/usr/local/opt/ruby/bin:${PATH}"       # Homebrew Ruby
    export PATH="${HOME}/.pyenv/bin:${PATH}"            # pyenv
    export PATH="${HOME}/.local/bin:${PATH}"            # pipx
    export PATH="${HOME}/go/bin:${PATH}"                # Go binaries
    export PATH="${PATH}:${HOME}/.snowsql/1.2.12"       # Snowflake CLI
    export PATH="${HOME}/bin:${PATH}"                   # Custom installed binaries
    export PATH="${PATH}:${HOME}/.local/bin"            # Ansible:::
    export PATH="${PATH}:${HOME}/.cabal/bin/git-repair" # Haskell binaries

    # add homebrew bins and manpages to path
    add_homebrew_tools_and_docs_to_path
}
