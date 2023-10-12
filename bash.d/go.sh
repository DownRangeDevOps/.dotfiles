log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  init
# ------------------------------------------------
function goenv() {
    log debug "Initializing goenv..."

    unset -f goenv

    eval "$(goenv init -)"
    add_to_path "prepend" "$(goenv prefix)/bin" # Go binaries

    command goenv "$@"
}
