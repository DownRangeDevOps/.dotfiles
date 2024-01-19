# shellcheck shell=bash

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]:-${(%):-%x}}]"
fi

# ------------------------------------------------
#  init
# ------------------------------------------------
function fuck() {
    if [[ -n "${DEBUG:-}" ]]; then
        log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Initializing thefuck..."
    fi

    unset -f fuck
    eval "$(thefuck --alias)"

    command fuck "$@"
}
