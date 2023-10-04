log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  init
# ------------------------------------------------
log debug "Initializing lua..."

set +ua
source "$(command -v luaver)"
set -ua
