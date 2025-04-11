# shellcheck shell=bash disable=SC2296

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]:-${(%):-%x}}]"
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
