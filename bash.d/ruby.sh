if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]}]"
fi

# ------------------------------------------------
#  init
# ------------------------------------------------
function rbenv() {
    if [[ -n "${DEBUG:-}" ]]; then
        log debug "[$(basename "${BASH_SOURCE[0]}")]: Initalizing rbenv..."
    fi

    unset -f rbenv
    eval "$(rbenv init - bash)"

    add_to_path "prepend" "$(rbenv prefix)/bin"

    $(which rbenv) "$@"
}
