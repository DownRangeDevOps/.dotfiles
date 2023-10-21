if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]}]"
fi

# ------------------------------------------------
#  init
# ------------------------------------------------
function luaver() {
    if [[ -n "${DEBUG:-}" ]]; then
        log debug "Initializing lua..."
    fi

    unset -f luaver

    # shellcheck disable=SC1090
    source "$(which luaver)"
}
