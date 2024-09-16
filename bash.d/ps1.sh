# shellcheck shell=bash

# ------------------------------------------------
#  helpers
# ------------------------------------------------
function __ps1_prompt() {
    local cli_element_order
    local cli_info_str

    local aws_profile
    local aws_vault
    local git_branch_state
    local shell_lvl
    local env
    local tf_workspace
    local time
    local virtualenv_name

    local path_with_tilde=${PWD/"${HOME}"/\~}

    aws_profile="${AWS_PROFILE:+aws:${AWS_PROFILE}}"
    aws_vault="${AWS_VAULT:+aws-vault:${AWS_VAULT}}"
    git_branch_state="$(__git_show_branch_state)"
    shell_lvl="$(is_subsh)"
    env="${TF_VAR_tenant:+env:${TF_VAR_tenant}}"
    tf_workspace="$(__get_terraform_workspace)"
    tf_workspace="${tf_workspace:+tfws:${tf_workspace}}"
    time="$(date +%R)"
    virtualenv_name="$(__get_virtualenv_name)"

    cli_element_order=(
        "${virtualenv_name}"
        "${aws_profile}"
        "${aws_vault}"
        "${env}"
        "${tf_workspace}"
    )

    cli_info_str="$(printf "%s" "${cli_element_order[@]}" | tr -s ' ')"

    cli_time=(
        "${time}"
        "${shell_lvl}"
    )

    cli_time_str="$(printf "%s" "${cli_time[@]}" | tr -s ' ')"

    if [[ -n "${git_branch_state}" ]]; then
        printf "%s\n" "${BLUE}┏${BOLD}[${RESET} ${YELLOW}${path_with_tilde}${BLUE} ${BOLD}]${RESET}${BLUE}━${BOLD}[${RESET} ${MAGENTA}${git_branch_state} ${BLUE}${BOLD}]${RESET}"
    else
        printf "%s\n" "${BLUE}┏[ ${YELLOW}${path_with_tilde} ${BLUE}]${RESET}"
    fi

    if [[ -n "${cli_info_str}" ]]; then
        printf "%s\n" "${BLUE}┣${BOLD}[${RESET} ${cli_time_str} ${BLUE}${BOLD}]${BLUE}━${BOLD}[ ${RESET}${cli_info_str}${BOLD}${BLUE} ]${RESET}"
    else
        printf "%s\n" "${BLUE}┣${BOLD}[${RESET} ${cli_time_str} ${BLUE}${BOLD}]${RESET}"
    fi

    PS1="${BLUE}┗❱ ${RESET}"
}

if [[ -z "${ZSH_VERSION:-}" &&  ! "${PROMPT_COMMAND:-}" =~ __ps1_prompt ]]; then
    PROMPT_COMMAND="${PROMPT_COMMAND:-}; __ps1_prompt"
else
    precmd() { __ps1_prompt; }
fi
