# shellcheck shell=bash disable=SC2296

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]:-${(%):-%x}}]"
fi

# shellcheck disable=SC1090,SC1091
safe_source "${HOME}/.bash_secrets"
