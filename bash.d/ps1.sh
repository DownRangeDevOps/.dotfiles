log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  helpers
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

function __get_shell_lvl() {
    LEVEL=1
    [[ -n ${NVIM_LISTEN_ADDRESS:-} ]] && LEVEL=2
    [[ ${SHLVL} -gt ${LEVEL} ]] && printf "%s" "${SHLVL}"
}

function __ps1_prompt() {
    local info
    local time
    local git_root
    local git_branch_with_state
    local ps1
    local shell_lvl
    local aws_vault
    local virtualenv_name
    local tf_workspace

    shell_lvl="$(__get_shell_lvl)"
    aws_vault=" $(__get_aws_vault) "
    virtualenv_name=" $(__get_virtualenv_name) "
    tf_workspace=" $(__get_terraform_workspace) "

    info="$(printf "%s" "${shell_lvl}${aws_vault}${virtualenv_name}${tf_workspace}" | trim)"

    if [[ -n ${info} ]]; then
        info="(${info}) "
    fi

    if __git_is_repo; then
        git_parent_path="$(dirname "$(__git_project_root)")"
        git_root="${YELLOW}git@${PWD/${git_parent_path}\//}${RESET}"
        git_branch_with_state="${MAGENTA}$(__git_show_branch_state)${RESET}"

        printf "%s\n" "${git_root} on ${git_branch_with_state}"
    else
        # `~` prints the path to $HOME
        printf "%s\n" "${YELLOW}${PWD/~/\~}${RESET}"
    fi

    time="$(date +%R) "
    ps1="${time}${info}\[${CYAN}\]→ \[${RESET}\]"
    PS1="${ps1}"
}

if [[ ! "${PROMPT_COMMAND:-}" =~ __ps1_prompt ]]; then
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}history -a ~/.bash_history; history -n ~/.bash_history; __ps1_prompt"
fi
