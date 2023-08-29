log debug ""
log debug "$(printf_callout ["${BASH_SOURCE[0]}"])"

# overwrites PS1 so do it first
source /usr/local/share/google-cloud-sdk/path.bash.inc

# ------------------------------------------------
#  helpers
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

function list_dir_cont() {
    local gnu_ls=/usr/local/opt/coreutils/libexec/gnubin/ls
    local lsopts=("--color=auto" "--almost-all")

    if [[ $1 == "--long" ]]; then
        shift
        lsopts+=("-l" "--classify" "--no-group" "--size" "--human-readable")
    fi

    if [[ -f ${gnu_ls} ]]; then
        ${gnu_ls} "${lsopts[@]}" "$@"
    else
        printf_error "GNU ls not found at ${gnu_ls}, falling back to /bin/ls"
        /bin/ls "${lsopts[@]}" "$@"
    fi
}
