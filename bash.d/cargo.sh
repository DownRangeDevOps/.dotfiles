log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  init
# ------------------------------------------------
function cargo() {
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading config..."

    unset -f cargo

    # shellcheck disable=SC1090,SC1091
    source "$HOME/.cargo/env"

    $(which cargo) "$@"
}
