# shellcheck disable=SC1090,SC1091,SC2034  # SC2034: ignore globals that are set for use elsewhere
set +ua
if [[ -n "${DEBUG:-}" ]]; then
    source "${HOME}/.dotfiles/lib/log.sh"
fi
set -ua

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]}]"
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading printing helpers..."
fi

# Colors
# BLACK=$(tput setaf 0)
# RED=$(tput setaf 1)
# GREEN=$(tput setaf 2)
# YELLOW=$(tput setaf 3)
# BLUE=$(tput setaf 4)
# MAGENTA=$(tput setaf 5)
# CYAN=$(tput setaf 6)
# WHITE=$(tput setaf 7)
# BOLD=$(tput bold)
# REVERSE=$(tput rev)
# RESET=$(tput sgr0)

export BLACK="[30m"
export RED="[31m"
export GREEN="[32m"
export YELLOW="[33m"
export BLUE="[34m"
export MAGENTA="[35m"
export CYAN="[36m"
export WHITE="[37m"
export BOLD="[1m"
export REVERSE="[7m"
export RESET="(B[m"

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

function printf_callout() {
    if [[ -n "${1:-}" ]]; then
        printf "%s\n" "${BOLD}${BLUE}==> ${RESET}${BOLD}${1}${RESET}"
    else
        printf_error "No msg provided, args: ${*}"
    fi
}

# UI
function prompt_to_continue() {
    read -p "${BLUE}${1:-Continue?} (y)[es|no] ${RESET}" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        printf "\n\n"
        return 0
    else
        printf "\n%s\n\n" "${BLUE}${2:-Ok, exiting.}${RESET}"
        [[ $0 == "${BASH_SOURCE[0]}" ]] && exit 3 || return 3
    fi
}

# Utils
function add_to_path() {
    local position="${1:-}"
    local new_path="${2:-}"

    case "${position}" in
    prepend)
        if [[ -n "${PATH:-}" ]]; then
            export PATH="${new_path}:${PATH}"
        else
            export PATH="${new_path}"
        fi
        ;;
    append)
        if [[ -n "${PATH:-}" ]]; then
            export PATH="${PATH}:${new_path}"
        else
            export PATH="${new_path}"
        fi
        ;;
    *)
        true
        ;;
    esac
}

function join() {
    local IFS=${1:-}
    __="${*:2}"
}

function fix_missing_newline() {
    # Add newline to EOF if missing
    for file in "$@"; do
        if [[ -s ${file} ]] && [[ "$(
            tail -c1 "${file}"
            echo x
        )" != $'\nx' ]]; then
            printf "\n" >>"${file}"
        fi
    done
}
