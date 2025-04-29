# shellcheck shell=bash

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [$0]"
fi

# ------------------------------------------------
#  config
# ------------------------------------------------
export ANSIBLE_VAULT_PASSWORDS="${HOME}/.ansible/vault-passwords"
export BITBUCKET_SSH_KEY="${HOME}/.ssh/id_rsa"
[[ -n ${ORG_NAME:-} ]] && export DEVOPS_REPO="${HOME}/dev/${ORG_NAME}/src/devops"

# ------------------------------------------------
#  helpers
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "$0")]: Loading helpers..."
fi

function ade() {
    if [[ -z ${1:-} ]]; then
        printf "%s\n" "Usage:"
        printf "%s\n" "    ade <environment>"
        return 3
    fi

    find "environments/${1}/" \
        -type f \
        -iname '*.vault.*' \
        -exec sh -c 'passfile="$1"; \
        ansible-vault decrypt \
        --vault-id $passfile' shell "${HOME}/.ansible/vault-passwords/${1}" {} \
        \;
}

function aes() {
    if [[ -z ${1:-} || -z ${2:-} ]]; then
        printf "%s\n" "Usage:"
        printf "%s\n" "    aes <environment> <variable name>"
        return 3
    fi

    if [[ -z "${ZSH_VERSION}" ]]; then
        read -p "${BLUE}${1:-String to encrypt:} ${RESET}" -sr
    else
        read -sr "REPLY?${BLUE}${1:-String to encrypt:} ${RESET}"
    fi


    ansible-vault encrypt_string --vault-id "${HOME}/.ansible/vault-passwords/${1}" -n "$2" "${REPLY}" |
        sed 's/^  */  /' |
        tee /dev/tty |
        pbcopy

    printf_callout "%s\n" "The result has been copied to your clipboard."
}

function ads() {
    if [[ -z ${1:-} || -z ${2:-} || -z ${3:-} ]]; then
        printf "%s\n" "Usage:"
        printf "%s\n" "    ads <environment> <yaml_file> <variable_path>"
        return 3
    fi

    yq -t read "${2}" "${3}" |
        ansible-vault decrypt --vault-password-file "${HOME}/.ansible/vault-passwords/${1:-}" |
        tee /dev/tty |
        pbcopy

    printf_callout "%s\n" "The result has been copied to your clipboard."
}
