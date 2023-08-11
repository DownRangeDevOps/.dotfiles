# vim: set ft=sh:

# Sexy Bash Prompt, inspired by "Extravagant Zsh Prompt"
# if [[ $COLORTERM = gnome-* && $TERM = xterm ]]  && infocmp gnome-256color >/dev/null 2>&1; then export TERM=gnome-256color
# elif [[ $TERM != dumb ]] && infocmp xterm-256color >/dev/null 2>&1; then export TERM=xterm-256color
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

function get_shell_lvl () {
    LEVEL=1
    [[ -n $NVIM_LISTEN_ADDRESS ]] && LEVEL=2
    [[ $SHLVL -gt $LEVEL ]] && printf "%s" "($SHLVL)"
}

function get_aws_vault () {
    [[ -n $AWS_VAULT ]] && printf "%s" "($AWS_VAULT)"
}

function get_terraform_workspace () {
    ls .terraform &>/dev/null && printf "%s" "($(terraform workspace show 2>/dev/null))"
}

function __ps1_prompt () {
    local time="$(date +%R)"
    local git_root="${YELLOW}$(git_project_root)${RESET}"
    local git_branch="${MAGENTA}$(parse_git_branch)${RESET}"

    if [[ -n "${git_branch}" ]]; then
        local git_prompt=" ${git_root} on ${git_branch}"
    else
        local git_prmopt=" "
    fi

    local info_line="${time}${git_prompt}"

    PS1="$(get_shell_lvl)$(get_aws_vault)$(get_virtualenv)$(get_terraform_workspace) \[${CYAN}\]→ \[${RESET}\]"
    printf "%s\n" "${info_line}"
}

PROMPT_COMMAND='history -a ~/.bash_history; history -n ~/.bash_history; __ps1_prompt'
