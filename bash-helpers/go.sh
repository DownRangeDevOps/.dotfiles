# go.sh
log debug ""
log debug "$(printf_callout ["${BASH_SOURCE[0]}"])"

# lazy init goenv
function goenv_alias() {
    for cmd in "${go_cmds[@]}"; do
        cmd=$(printf "%s" "${cmd}" | trim)

        if [[ "$1" == "create" ]]; then
            # shellcheck disable=SC2139
            alias "${cmd}"=goenv_lazy_init
        elif [[ "$1" == "remove" ]]; then
            unalias "${cmd}" 2>/dev/null
        fi
    done
}

if [[ -z "${GOENV_ROOT:-}" ]]; then
    goenv_alias create
fi

function goenv_lazy_init() {
    # shellcheck disable=SC2155
    local CMD
    CMD="$(fc -ln | tail -1 | trim)"
    unset -f goenv_lazy_init

    printf_callout "%s\n" "goenv has not been initialized, initializing now..."
    goenv_alias remove
    eval "$(goenv init -)"

    # add go bins to path
    export PATH="${PATH}:${GOPATH}/bin"

    printf_callout "%s\n" "Done. Running $(green \`${CMD}\`)${BOLD}..."
    ${CMD}
}

mapfile -t go_cmds <<-EOF
    go
    goenv
EOF
