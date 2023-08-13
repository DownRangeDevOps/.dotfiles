# vim: set ft=bash:
# ansible.sh
logger "" "[${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  config
# ------------------------------------------------
export ANSIBLE_VAULT_PASSWORDS="$HOME/.ansible/vault-passwords"
export BITBUCKET_SSH_KEY="$HOME/.ssh/id_rsa"
export DEVOPS_REPO="$HOME/dev/measurabl/src/devops"

# ------------------------------------------------
#  alises
# ------------------------------------------------
# Ansible vault shortcuts
alias aav='ansible-vault view'

# ------------------------------------------------
#  helpers
# ------------------------------------------------
logger "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

function ade() {
    if [[ -z $1 ]]; then
        printf "%s\n" "Usage:"
        printf "%s\n" "    ade <environment>"
        return 1
    fi
  find "environments/${1}/" \
    -type f \
    -iname '*.vault.*' \
    -exec sh -c 'passfile="$1"; \
        ansible-vault decrypt \
        --vault-id $passfile' shell "$HOME/.ansible/vault-passwords/${1}" {} \
      \;
}

function aes() {
    if [[ -z $1 || -z $2 ]]; then
        printf "%s\n" "Usage:"
        printf "%s\n" "    aes <environment> <variable name>"
        return 1
    fi
    read -p "String to encrypt: " -sr
    ansible-vault encrypt_string --vault-id "$HOME/.ansible/vault-passwords/${1}" -n "${2}" "${REPLY}" \
        | sed 's/^  */  /' \
        | tee /dev/tty \
        | pbcopy
    printf "%s\n" "The result has been copied to your clipboard."
}

function ads() {
    if [[ -z $1 || -z $2 || -z $3 ]]; then
        printf "%s\n" "Usage:"
        printf "%s\n" "    ads <environment> <yaml_file> <variable_path>"
        return 1
    fi
    yq -t read "${2}" "${3}" \
    | ansible-vault decrypt --vault-password-file "$HOME/.ansible/vault-passwords/${1}" \
    | tee /dev/tty \
    | pbcopy
    printf "%s\n" "The result has been copied to your clipboard."
}
