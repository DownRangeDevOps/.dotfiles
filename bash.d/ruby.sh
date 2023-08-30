log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  config
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Initalizing rbenv..."

# lazy init rbenv
function rbenv_alias() {
    local go_cmds
    mapfile -t go_cmds <<EOF
rbenv
rbenv-install
rbenv-uninstall
rbs
gem
EOF

    for cmd in "${go_cmds[@]}"; do
        cmd=$(printf "%s" "${cmd}" | trim)

        if [[ ${1:-} == "create" ]]; then
            # shellcheck disable=SC2139
            alias "${cmd}=rbenv_lazy_init"
        elif [[ ${1:-} == "remove" ]]; then
            unalias "${cmd}" 2>/dev/null
        fi
    done
}

function rbenv_lazy_init() {
    local last_cmd
    last_cmd=$(fc -l | tail -1 | cut -d ' ' -f 2-)

    log debug "$(printf_callout Initalizing goenv...)"
    unset -f rbenv_lazy_init

    printf_warning "rbenv has not been initialized, initializing now..." >&2

    set +u
    rbenv_alias remove
    export RBENV_INITALIZED=1
    eval "$(rbenv init -)"
    add_to_path "prepend" "$(rbenv prefix)/bin"
    set -u

    $last_cmd
}

if [[ -z "${RBENV_INITALIZED:-}" ]]; then
    rbenv_alias create
fi
