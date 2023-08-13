# ps1.sh
logger "" "[${BASH_SOURCE[0]}]"

# Sexy Bash Prompt, inspired by "Extravagant Zsh Prompt"
# if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
#     export TERM=gnome-256color
# elif [[ $TERM != dumb ]] && infocmp xterm-256color >/dev/null 2>&1; then
#     export TERM=xterm-256color
# fi

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BOLD=$(tput bold)
RESET=$(tput sgr0)

export RED
export GREEN
export YELLOW
export BLUE
export MAGENTA
export CYAN
export WHITE
export BOLD
export RESET

# ------------------------------------------------
#  helpers
# ------------------------------------------------
logger "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

function get_shell_lvl () {
    LEVEL=1
    [[ -n ${NVIM_LISTEN_ADDRESS} ]] && LEVEL=2
    [[ ${SHLVL} -gt ${LEVEL} ]] && printf "%s" "${SHLVL}"
}

function __ps1_prompt () {
    local info
    local time
    local git_root
    local git_branch

    info="$(get_shell_lvl)$(get_aws_vault)$(get_virtualenv_name)$(get_terraform_workspace)"
    time="$(date +%R) "
    git_root="${YELLOW}$(git_project_root)${RESET}"
    git_branch="${MAGENTA}$(parse_git_branch)${RESET}"

    if __git_is_repo; then
        printf "%s\n" "${git_root} on ${git_branch}"
    else
        printf "%s\n" "${YELLOW}${PWD/~/\~}${RESET}"
    fi

    if [[ -n ${info} ]]; then
        info="(${info}) "
    fi

    local ps1
    ps1="${time}${info}\[${CYAN}\]→ \[${RESET}\]"
    PS1="${ps1}"
}

PROMPT_COMMAND='history -a ~/.bash_history; history -n ~/.bash_history; __ps1_prompt'
