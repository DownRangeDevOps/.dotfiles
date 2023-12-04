if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]}]"
fi

# ------------------------------------------------
# init (jump around)
# ------------------------------------------------
function z() {
    if [[ -n "${DEBUG:-}" ]]; then
        log debug "[$(basename "${BASH_SOURCE[0]}")]: Initializing z..."
    fi

    unset -f z

    # shellcheck disable=SC1091
    safe_source "${HOMEBREW_PREFIX}/etc/profile.d/z.sh"

    _z 2>&1 "$@"
}
