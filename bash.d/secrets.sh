log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# shellcheck disable=SC1090,SC1091
if [[ -f "${HOME}/.bash_secrets" ]]; then
    source "${HOME}/.bash_secrets"
fi
