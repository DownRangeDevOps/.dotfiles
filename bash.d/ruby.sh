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

    eval "$($(which rbenv) init - bash)"

    set -ua

    add_to_path "prepend" "$($(which rbenv) prefix)/bin"
}
