log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  init
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Initalizing rbenv..."

log debug "Initalizing goenv..."

set +u
eval "$(rbenv init -)"
set -u

add_to_path "prepend" "$(rbenv prefix)/bin"
