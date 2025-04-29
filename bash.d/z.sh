# shellcheck shell=bash

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [$0]"
fi

# ------------------------------------------------
# init (jump around)
# ------------------------------------------------
function z() {
    if [[ -n "${DEBUG:-}" ]]; then
        log debug "[$(basename "$0")]: Initializing z..."
    fi

    unset -f z

    # shellcheck disable=SC1091
    safe_source "${HOMEBREW_PREFIX}/etc/profile.d/z.sh"

    _z 2>&1 "$@"
}
