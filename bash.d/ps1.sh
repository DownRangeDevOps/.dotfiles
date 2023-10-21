log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  helpers
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

function __ps1_prompt() {
    local path_with_tilde=${PWD/~/\~} # `~` expands to user home dir

    local time
    local shell_lvl
    local aws_vault
    local virtualenv_name
    local tf_workspace

    time="$(date +%R) "
    aws_vault=" $(__get_aws_vault) "
    virtualenv_name=" $(__get_virtualenv_name) "
    tf_workspace=" $(__get_terraform_workspace) "


    local info
    info="$(printf "%s" "${aws_vault}${virtualenv_name}${tf_workspace}" | trim)"

    if [[ -n ${info} ]]; then
        info="(${info}) "
    fi

    if __git_is_repo; then
        printf "%s\n" "${YELLOW}${path_with_tilde}${RESET} on ${MAGENTA}$(__git_show_branch_state)${RESET}"
    else
        printf "%s\n" "${YELLOW}${path_with_tilde}${RESET}"
    fi


    PS1="${time}${info}\[${CYAN}\]→ \[${RESET}\]"
}

if [[ ! "${PROMPT_COMMAND:-}" =~ __ps1_prompt ]]; then
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}history -a ~/.bash_history; history -n ~/.bash_history; __ps1_prompt"
fi
