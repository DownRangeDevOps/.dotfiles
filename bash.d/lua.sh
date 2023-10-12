log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  init
# ------------------------------------------------
function luaver() {
    log debug "Initializing lua..."

    unset -f luaver

    # shellcheck disable=SC1090
    source "$(which luaver)"
}
