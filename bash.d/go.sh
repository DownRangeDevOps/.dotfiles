log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  init
# ------------------------------------------------
log debug "Initializing goenv..."

set +ua
eval "$(goenv init -)"
set -ua

add_to_path "prepend" "$(goenv prefix)/bin" # Go binaries
