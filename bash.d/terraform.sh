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
            printf "%s" "${workspace}"
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
        terraform "$@" |& tee tfplan.log
        parse_plan_diff tfplan.log
    else
        terraform "$@"
    fi
}

function terraform_fmt_project() {
    local cur_dir="${PWD}"

    cd "$(git_project_root)" || return 1
    terraform fmt -recursive
    cd "${cur_dir}" || return 1
}

function parse_plan_diff() {
    local infile="${1:-"tfplan.log"}"
    local nocolorfile="${infile}.nocolor"
    local outfile="${2:-"change-log.tfplan"}"
    local patterns=("destroyed" "created" "replaced" "forces replacement")

    ansifilter --input="${infile}" --output="${nocolorfile}"
    sed -i -E "1,/^$/d" "${nocolorfile}"

    true >| "${outfile}"
    printf "%s\n\n" "Plan created: $(date)" >> "${outfile}"


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

    if [[ -n "${TF_VAR_tenant:-}" ]]; then
        infile="${TF_VAR_tenant:-}.${infile}"
        mv -f "${outfile}" "${TF_VAR_tenant:-}.${outfile}"
    fi

    rm -f "${infile}"
    mv -f "${nocolorfile}" "${infile}"
}

# function terraform_foce_unlock() {
# }
