log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  init
# ------------------------------------------------
log debug "Initializing goenv..."

set +u
eval "$(goenv init -)"
set -u

add_to_path "prepend" "$(goenv prefix)/bin" # Go binaries
