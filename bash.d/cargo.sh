# shellcheck shell=bash

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]:-${(%):-%x}}]"
fi

# ------------------------------------------------
#  init
# ------------------------------------------------
function cargo() {
    if [[ -n "${DEBUG:-}" ]]; then
        log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Loading config..."
    fi

    unset -f cargo

    # shellcheck disable=SC1090,SC1091
    safe_source "$HOME/.cargo/env"

    command cargo "$@"
}
