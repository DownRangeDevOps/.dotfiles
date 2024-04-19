# shellcheck shell=bash

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]:-$0}]"
fi

# ------------------------------------------------
#  init
# ------------------------------------------------
function goenv() {
    if [[ -n "${DEBUG:-}" ]]; then
        log debug "Initializing goenv..."
    fi

    unset -f goenv

    eval "$(goenv init -)"
    add_to_path "prepend" "$(goenv prefix)/bin" # Go binaries

    command goenv "$@"
}
