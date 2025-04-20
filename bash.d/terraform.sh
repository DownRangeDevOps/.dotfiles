# shellcheck shell=bash disable=SC2296

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

        if [[ -s tfplan.log ]]; then
            parse_plan_diff tfplan.log
        else
            rm -f tfplan.log
        fi
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
    local patterns=(
        "will be destroyed"
        "will not be destroyed"
        "created"
        "will be updated in-place"
        "replaced"
        "forces replacement"
    )

    ansifilter --input="${infile}" --output="${nocolorfile}"
    sed -i -E "1,/^$/d" "${nocolorfile}" # remove state refresh logging

    rm -f "raw-${infile}"
    cp -f "${nocolorfile}" "raw-${infile}"

    true >| "${outfile}" # create or truncate the file
    printf "%s\n" "Plan created: $(date)" >> "${outfile}"
    printf "%s\n\n" "$(rg '^(Plan:\s|No changes)')" >> "${outfile}"


    for pat in "${patterns[@]}"; do
        {
            if [[ -n "${ZSH_VERSION}" ]]; then
                printf "%s\n" "==== ${pat:u}:"
            else
                printf "%s\n" "==== ${pat^^}:"
            fi
            rg "#.*\b${pat}\b$" "${nocolorfile}" | sed -E "s/( will | must ).*//"
            printf "\n"
        } >>"${outfile}"
    done

    # printf "%s\n" "==== UPDATED:" >> "${outfile}"
    # extract_update_sections "${nocolorfile}"

    rm -f "${infile}"

    if [[ -n "${TF_VAR_tenant:-}" ]]; then
        infile="${TF_VAR_tenant:-}.${infile}"
        mv -f "${outfile}" "${TF_VAR_tenant:-}.${outfile}"
    fi

    mv -f "${nocolorfile}" "${infile}"
}

function extract_update_sections() {
    local plan_output="$1"
    local in_block=false
    local block_lines=()

    while IFS= read -r line; do
        if [[ "${line}" =~ "updated in-place"$ ]]; then
            in_block=true
            block_lines+=("${line}")
        elif ${in_block}; then
            if [[ -z "${line}" ]]; then
                # We've reached a blank line, print the collected block
                for blk_line in "${block_lines[@]}"; do
                    if [[ "${blk_line}" =~ ^\s*# || "${blk_line}" =~ ^\s*~ ]]; then
                        printf "%s\n" "${blk_line}"
                    fi
                done
                printf "\n"
                block_lines=()
                in_block=false
            else
                block_lines+=("${line}")
            fi
        fi
    done < "${plan_output}"

    # Print any remaining block at the end of the file
    if $in_block; then
        for blk_line in "${block_lines[@]}"; do
            if [[ "${blk_line}" =~ ^# || "${blk_line}" =~ ^~ ]]; then
                printf "%s\n" "${blk_line}"
            fi
        done
    fi
}
