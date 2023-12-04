if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]}]"
fi

# shellcheck disable=SC1090,SC1091
if [[ -f "${HOME}/.bash_secrets" ]]; then
    safe_source "${HOME}/.bash_secrets"
fi
