log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# lazy init goenv
function goenv_alias() {
    local go_cmds
    mapfile -t go_cmds <<-EOF
go
goenv
EOF

    for cmd in "${go_cmds[@]}"; do
        cmd=$(printf "%s" "${cmd}" | trim)

        if [[ ${1:-} == "create" ]]; then
            # shellcheck disable=SC2139
            alias "${cmd}=goenv_lazy_init"
        elif [[ ${1:-} == "remove" ]]; then
            unalias "${cmd}" 2>/dev/null
        fi
    done
}

function goenv_lazy_init() {
    local last_cmd
    last_cmd=$(fc -l | tail -1 | cut -d ' ' -f 2-)

    log debug "Initalizing goenv..."
    unset -f goenv_lazy_init

    printf_warning "goenv has not been initialized, initializing now..." >&2

    set +u
    goenv_alias remove
    eval "$(goenv init -)"
    add_to_path "prepend" "$(goenv prefix)/bin" # Go binaries
    set -u

    $last_cmd
}

if [[ -z ${GOENV_ROOT:-} ]]; then
    goenv_alias create
fi
