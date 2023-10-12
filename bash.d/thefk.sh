log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  init
# ------------------------------------------------
function fuck() {
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Initializing thefuck..."

    unset -f fuck
    eval "$(thefuck --alias)"

    $(which fuck) "$@"
}
