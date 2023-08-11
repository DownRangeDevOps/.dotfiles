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

function parse_git_branch () {
    git_branch | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

function parse_git_dirty () {
    case $(git status 2>/dev/null) in
        *"Changes not staged for commit"*)
            printf "%s\n" " ${RED}✗";;
        *"Changes to be committed"*)
            printf "%s\n" " ${YELLOW}✗";;
        *"nothing to commit"*)
            printf "%s\n" "";;
    esac
}

function get_virtualenv () {
    if [[ $VIRTUAL_ENV ]]; then
        printf "%s\n" " ($(basename "$VIRTUAL_ENV"))"
    else
        printf "%s\n" ""
    fi
}

function git_project_parent() {
    printf "%s" "$(git rev-parse --show-toplevel 2>/dev/null)/.."
}

function git_project_root () {
    if [[ -n $(git branch 2>/dev/null) ]]; then
        printf "%s\n" "git@$(realpath --relative-to="$(git_project_parent)" .)"
    else
        printf "%s\n" "${PWD/~/\~}"
    fi
}

function git_branch () {
    git branch --no-color 2>/dev/null
}

function get_shell_lvl () {
    LEVEL=1
    [[ -n $NVIM_LISTEN_ADDRESS ]] && LEVEL=2
    [[ $SHLVL -gt $LEVEL ]] && printf "%s\n" "($SHLVL)"
}

function get_aws_vault () {
    [[ -n $AWS_VAULT ]] && printf "%s\n" "($AWS_VAULT)"
}

function get_terraform_workspace () {
    ls .terraform &>/dev/null && printf "%s\n" -n "($(terraform workspace show 2>/dev/null))"
}

function __ps1_prompt () {
    PS1="$(get_shell_lvl)$(get_aws_vault)$(get_virtualenv)$(get_terraform_workspace) \[${CYAN}\]→ \[${RESET}\]"
    printf "%s\n" "\
$(date +%R) \
${YELLOW}$(git_project_root)${RESET}\
$([[ -n $(git_branch) ]] && printf "%s\n" " on ")\
${MAGENTA}$(parse_git_branch)${RESET}"
}

PROMPT_COMMAND='history -a ~/.bash_history; history -n ~/.bash_history; __ps1_prompt'
