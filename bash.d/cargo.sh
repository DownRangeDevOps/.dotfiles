log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# shellcheck disable=SC1090,SC1091
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading config..."

set +ua
# shellcheck disable=SC1090,SC1091
source "$HOME/.cargo/env"
set -ua
