# shellcheck shell=bash

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]:-${(%):-%x}}]"
fi

# ------------------------------------------------
#  helpers
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Loading helpers..."
fi

function __ps1_prompt() {
    local path_with_tilde=${PWD/~/\~} # `~` expands to user home dir

    local time
    local shell_lvl
    local aws_vault
    local virtualenv_name
    # local tf_workspace
    local git_branch_state

    time="$(date +%R)"
    aws_vault=" $(__get_aws_vault) "
    virtualenv_name=" $(__get_virtualenv_name) "
    # tf_workspace=" $(__get_terraform_workspace) "  # I never use workspaces
    shell_lvl="$(is_subsh)"
    git_branch_state="$(__git_show_branch_state)"

    local info
    info="$(printf "%s" "${aws_vault:-}${virtualenv_name:-}" | trim)"

    if [[ -n ${info:-} ]]; then
        info="(${info}) "
    fi

    if [[ -n "${git_branch_state:-}" ]]; then
        printf "%s\n" "${YELLOW}${path_with_tilde}${RESET} on ${MAGENTA}${git_branch_state:-}${RESET}"
    else
        printf "%s\n" "${YELLOW}${path_with_tilde}${RESET}"
    fi

    if [[ -n "${ZSH_VERSION:-}" ]]; then
        PS1="${time:-}${shell_lvl:-}${info:-} ${CYAN}→ ${RESET}"
    else
        PS1="${time:-}${shell_lvl:-}${info:-} \[${CYAN}\]→ \[${RESET}\]"
    fi
}

if [[ -z "${ZSH_VERSION:-}" &&  ! "${PROMPT_COMMAND:-}" =~ __ps1_prompt ]]; then
    PROMPT_COMMAND="${PROMPT_COMMAND:-}history -a ~/.bash_history; history -r ~/.bash_history; __ps1_prompt"
else
    precmd() { __ps1_prompt; }
fi
