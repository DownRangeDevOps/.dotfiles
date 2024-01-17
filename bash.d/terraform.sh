# shellcheck shell=bash

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]}]"
fi

# ------------------------------------------------
#  config
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading config..."
fi

complete -C "${HOMEBREW_PREFIX}/bin/terraform" terraform

# ------------------------------------------------
#  helpers
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."
fi

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

function terraform_plan() {
    # local tmpfile
    # tmpfile=$(mktmp)
    #
    # terraform plan "$@" "2>${tmpfile}" | bat "$(<"${tmpfile}")"
    terraform plan "$@"
}

function parse_plan_diff() {
    local infile="${1:-tfplan}"
    local outfile="${2:-"change-log.tfplan"}"
    local patterns=("destroyed" "created" "replaced" "forces replacement")

    if [[ -f ${outfile} ]]; then
        if ! prompt_to_continue "${outfile} exists, overwrite?"; then
            return 6
        fi
    fi

    true >|"${outfile}"

    for pat in "${patterns[@]}"; do
        {
            printf "%s\n" "==== ${pat^^}"
            rg -N "$pat" "${infile}"
            printf "\n"
        } >>"${outfile}"
    done
}
