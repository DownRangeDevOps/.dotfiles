# shellcheck shell=bash

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [$0]"
fi

# ------------------------------------------------
#  aws
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "$0")]: Loading aws config..."
fi

export AWS_ASSUME_ROLE_TTL=1h
export AWS_SESSION_TTL=12h

# aws vault
export AWS_VAULT_BACKEND=file
export AWS_SESSION_TOKEN_TTL=12h

# ------------------------------------------------
#  aws-vault (https://github.com/99designs/aws-vault)
#  usage: https://github.com/99designs/aws-vault/blob/master/USAGE.md
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "$0")]: Loading aws vault helpers..."
fi

function aws-vault() {
    unset -f aws-vault

    set -ua
    eval "$(curl -fs https://raw.githubusercontent.com/99designs/aws-vault/master/contrib/completions/bash/aws-vault.bash)"
    set +ua

    command aws-vault "$@"
}
