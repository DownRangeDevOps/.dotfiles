# lib.sh
# shellcheck disable=SC2034 # ignore globals that are set for use elsewhere

logger "" "[${BASH_SOURCE[0]}]"

logger "[$(basename "${BASH_SOURCE[0]}")]: Loading printing helpers..."

function prompt_to_continue() {
    read -p "${BLUE}${1:-Continue?} (y)[es|no] ${RESET}" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        printf "\n\n"
        return 0
    else
        printf "\n%s\n\n" "${BLUE}${2:-Ok, exiting.}${RESET}"
        [[ "$0" == "${BASH_SOURCE[0]}" ]] && exit 3 || return 3
    fi
}

function join() {
    local IFS=$1
    __="${*:2}"
}

# Formatting
function indent_output() {
    local indent_size=4
    local indent_levels=1

    if [[ $1 =~ ^[1-9]+ ]]; then
        indent_levels=$1
    fi

    pr --omit-header --indent $(( indent_levels * indent_size ))
}

function printf_callout() {
    printf "%s\n" "${BOLD}==> ${1}${RESET}"
}

# Colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BOLD=$(tput bold)
REVERSE=$(tput rev)
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

# Color printf
alias bold=printf_bold
function printf_bold() {
    printf "%b\n" "${BOLD}${*}${RESET}"
}

alias green=printf_green
function printf_green() {
    printf "%b\n" "${GREEN}${*}${RESET}"
}

alias yellow=printf_yellow
function printf_yellow() {
    printf "%b\n" "${YELLOW}${*}${RESET}"
}

alias red=printf_red
function printf_red() {
    printf "%b\n" "${RED}${*}${RESET}"
}

# Bold color printf
function printf_success() {
    printf "%b\n" "${BOLD}${GREEN}${*}${RESET}"
}

function printf_warning() {
    printf "%b\n" "${BOLD}${YELLOW}${*}${RESET}"
}

function printf_error() {
    printf "%b\n" "${BOLD}${RED}${*}${RESET}"
}
