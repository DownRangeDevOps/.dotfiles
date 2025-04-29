# shellcheck shell=bash

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [$0]"
fi

# ------------------------------------------------
#  init
# ------------------------------------------------
function fuck() {
    if [[ -n "${DEBUG:-}" ]]; then
        log debug "[$(basename "$0")]: Initializing thefuck..."
    fi

    unset -f fuck
    eval "$(thefuck --alias)"

    command fuck "$@"
}
