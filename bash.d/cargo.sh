if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]}]"
fi

# ------------------------------------------------
#  init
# ------------------------------------------------
function cargo() {
    if [[ -n "${DEBUG:-}" ]]; then
        log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading config..."
    fi

    unset -f cargo

    # shellcheck disable=SC1090,SC1091
    source "$HOME/.cargo/env"

    $(which cargo) "$@"
}
