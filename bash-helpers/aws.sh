# vim: set ft=sh:

# aws-vault
export AWS_SESSION_TOKEN_TTL="12h"

# alises
alias av="aws-vault"
alias ave="aws-vault exec"
alias avr="aws-vault exec msr-root --"
alias ava="aws-vault exec msr-amzn --"
alias avs="aws-vault exec msr-staging --"
alias avo="aws-vault exec msr-ops-sbx --"
alias avsci="aws-vault exec msr-sci-sbx --"

# helpers
function get_aws_vault () {
    [[ -n ${AWS_VAULT} ]] && printf "%s" " aws:${AWS_VAULT} "
}

function ave() {
    aws-vault exec "${@}"
}

function ave-sbx() {
    aws-vault exec ryan-msr-ops-sbx -- "${@}"
}
