# shellcheck shell=bash

# ------------------------------------------------
#  helpers
# ------------------------------------------------
function __ps1_prompt() {
    local cli_element_order
    local cli_info_str

    local aws_vault
    local git_branch_state
    local shell_lvl
    local tf_env
    local tf_workspace
    local time
    local virtualenv_name

    local path_with_tilde=${PWD/"${HOME}"/\~}

    # shellcheck disable=SC2034
    aws_vault="${AWS_VAULT:-}"
    if [[ -n "${aws_vault}" ]]; then
        aws_vault="aws-vault:${aws_vault}"
    fi

    # shellcheck disable=SC2034
    git_branch_state="$(__git_show_branch_state)"

    # shellcheck disable=SC2034
    shell_lvl="$(is_subsh)"

    # shellcheck disable=SC2034
    tf_env="${TF_VAR_tenant:-}"
    if [[ -n "${tf_env}" ]]; then
        tf_env="tfenv:${tf_env}"
    fi

    # shellcheck disable=SC2034
    tf_workspace="$(__get_terraform_workspace)"
    if [[ -n "${tf_workspace}" ]]; then
        tf_workspace="tfws:${tf_workspace}"
    fi

    # shellcheck disable=SC2034
    time="$(date +%R)"

    # shellcheck disable=SC2034
    virtualenv_name="$(__get_virtualenv_name)"

    cli_element_order=(
        "${virtualenv_name:-}"
        "${aws_vault:-}"
        "${tf_env:-}"
        "${tf_workspace:-}"
    )

    cli_info_str="$(awk '{$1=$1;print}' <<< "${cli_element_order[*]}")"

    cli_time=(
        "${time:-}"
        "${shell_lvl:-}"
    )

    cli_time_str="$(awk '{$1=$1;print}' <<< "${cli_time[*]}")"

    if [[ -n "${git_branch_state:-}" ]]; then
        printf "%s\n" "${BLUE}┏${BOLD}[${RESET} ${YELLOW}${path_with_tilde}${BLUE} ${BOLD}]${RESET}${BLUE}━${BOLD}[${RESET} ${MAGENTA}${git_branch_state:-} ${BLUE}${BOLD}]${RESET}"
    else
        printf "%s\n" "${BLUE}┏[ ${YELLOW}${path_with_tilde} ${BLUE}]${RESET}"
    fi

    if [[ -n "${cli_info_str:-}" ]]; then
        printf "%s\n" "${BLUE}┣${BOLD}[${RESET} ${cli_time_str:-} ${BLUE}${BOLD}]${BLUE}━${BOLD}[ ${RESET}${cli_info_str}${BOLD}${BLUE} ]${RESET}"
    else
        printf "%s\n" "${BLUE}┣${BOLD}[${RESET} ${cli_time_str:-} ${BLUE}${BOLD}]${RESET}"
    fi

    if [[ -n "${ZSH_VERSION:-}" ]]; then
        PS1="${BLUE}┗❱ ${RESET}"
    else
        PS1="\[${BLUE}\]┗❱ \[${RESET}\]"
    fi
}

if [[ -z "${ZSH_VERSION:-}" &&  ! "${PROMPT_COMMAND:-}" =~ __ps1_prompt ]]; then
    PROMPT_COMMAND="${PROMPT_COMMAND:-}; __ps1_prompt"
else
    precmd() { __ps1_prompt; }
fi
