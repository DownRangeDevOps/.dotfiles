log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  config
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading config..."

export AWS_ASSUME_ROLE_TTL=1h
export AWS_SESSION_TTL=12h

# aws vault
export AWS_VAULT_BACKEND=file
export AWS_SESSION_TOKEN_TTL=12h

# ------------------------------------------------
#  helpers
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

function __get_aws_vault() {
    [[ -n ${AWS_VAULT:-} ]] && printf "%s" "aws:${AWS_VAULT}"
}

function ave() {
    aws-vault exec "${@}"
}

function ave-sbx() {
    aws-vault exec ryan-msr-ops-sbx -- "${@}"
}
