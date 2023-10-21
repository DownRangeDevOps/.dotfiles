log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  config
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading config..."

complete -C "${BREW_PREFIX}/bin/terraform" terraform

# ------------------------------------------------
#  helpers
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

function __get_terraform_workspace() {
    if [[ -d .terraform ]]; then
        local workspace
        workspace="$(terraform workspace show 2>/dev/null)"

        if [[ "${workspace}" != "default" ]]; then
            printf "%s" "tf:${workspace}"
        fi
    fi
}

function init_all_modules() {
    ALL_MODULES=find_all_terraform_modules

    for module in ${ALL_MODULES}; do
        printf "%s\n" "${module}"
        (cd "${module}" && terraform init)
    done
}

function validate_all_modules() {
    ALL_MODULES=find_all_terraform_modules

    for module in ${ALL_MODULES}; do
        printf_callout "%s\n" "${module}"
        (cd "${module}" && terraform validate)
    done
}
