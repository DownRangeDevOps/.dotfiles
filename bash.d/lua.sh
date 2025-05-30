# shellcheck shell=bash

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [$0]"
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
    safe_source "$(which luaver)"
}
