# shellcheck shell=bash

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]}]"
fi

# ------------------------------------------------
#  init
# ------------------------------------------------
function rbenv_init() {
    set +ua
    # shellcheck disable=SC1091
    source "${HOME}/.dotfiles/bash-init/rbenv.sh"
    set -ua

    add_to_path "prepend" "$($(which rbenv) prefix)/bin"
    export RBENV_INITALIZED=1
}

function rbenv() {
    if [[ -z "${RBENV_INITALIZED:-}" || "${1:-}" == "init" ]]; then
        rbenv_init
    fi

    if [[ "${1:-}" != "init" ]]; then
        "$(which rbenv)" "$@"
    fi
}
