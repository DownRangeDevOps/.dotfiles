# cargo.sh
log debug ""
log debug "$(printf_callout ["${BASH_SOURCE[0]}"])"

# shellcheck disable=SC1091
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading config..."

source ~/.rsvm/current/cargo/env
