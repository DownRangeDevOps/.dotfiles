log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  init
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Initalizing rbenv..."

log debug "Initalizing goenv..."

set +au
eval "$(rbenv init -)"
set -au

add_to_path "prepend" "$(rbenv prefix)/bin"
