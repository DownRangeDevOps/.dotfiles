# vim: set ft=sh:
# cargo.sh
logger "" "[${BASH_SOURCE[0]}]"

# shellcheck disable=SC1091
logger "[$(basename "${BASH_SOURCE[0]}")]: Loading config..."

source "$HOME/.rsvm/current/cargo/env"
