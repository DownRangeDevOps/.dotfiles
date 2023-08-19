# cargo.sh
log debug "\n[${BASH_SOURCE[0]}]"

# shellcheck disable=SC1091
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading config..."

source "$HOME/.rsvm/current/cargo/env"
