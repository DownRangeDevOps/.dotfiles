log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  init
# ------------------------------------------------
function rbenv() {
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Initalizing rbenv..."

    unset -f rbenv
    eval "$(rbenv init - bash)"

    add_to_path "prepend" "$(rbenv prefix)/bin"

    $(which rbenv) "$@"
}
