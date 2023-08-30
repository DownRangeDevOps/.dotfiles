log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# shellcheck disable=SC1090,SC1091
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading config..."

set +u
# shellcheck disable=SC1090,SC1091
source "${HOME}/.rsvm/current/cargo/env"
set -u
