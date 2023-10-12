log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
# init (jump around)
# ------------------------------------------------
function z() {
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Initializing z..."

    unset -f z

    # shellcheck disable=SC1091
    source "${BREW_PREFIX}/etc/profile.d/z.sh"

    _z 2>&1 "$@"
}
