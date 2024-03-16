# shellcheck shell=bash

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]:-${(%):-%x}}]"
fi

# ------------------------------------------------
#  config
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Loading config..."
fi

complete -C "${HOMEBREW_PREFIX}/bin/terraform" terraform

# ------------------------------------------------
#  helpers
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Loading helpers..."
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

function terraform_wrapper() {
    if [[ "$1" == plan ]]; then
        terraform "$@" | \
            tee tfplan && \
            ansifilter -i tfplan -o tfplan.nocolor && \
            parse_plan_diff tfplan.nocolor
    else
        terraform "$@"
    fi
}

function parse_plan_diff() {
    local infile="${1:-"tfplan"}"
    local nocolorfile="${infile}.nocolor"
    local outfile="${2:-"change-log.tfplan"}"
    local patterns=("destroyed" "created" "replaced" "forces replacement")

    ansifilter -i "${infile}" -o "${nocolorfile}"
    true >|"${outfile}"

    for pat in "${patterns[@]}"; do
        {
            if [[ -n "${ZSH_VERSION}" ]]; then
                printf "%s\n" "==== ${pat:u}"
            else
                printf "%s\n" "==== ${pat^^}"
            fi
            rg -N "\b${pat}\b" "${nocolorfile}" | sed -E "s/( will | must ).*//"
            printf "\n"
        } >>"${outfile}"
    done
}
