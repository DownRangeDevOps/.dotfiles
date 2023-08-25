# cargo.sh
log debug ""
log debug "$(printf_callout ["${BASH_SOURCE[0]}"])"

# shellcheck disable=SC1091
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading config..."

# shellcheck disable=SC1090,SC1091
source "${HOME}/.rsvm/current/cargo/env"
