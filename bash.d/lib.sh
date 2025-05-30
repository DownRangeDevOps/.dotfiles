# shellcheck shell=bash disable=SC1090,SC1091,SC2034
if [[ -n "${DEBUG:-}" ]]; then
    set +ua
    [[ -f "${HOME}/.dotfiles/lib/log.sh" ]] && "${HOME}/.dotfiles/lib/log.sh"
    set -ua
    log debug ""
    log debug "==> [$0]"
    log debug "[$(basename "$0")]: Loading printing helpers..."
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
export DEFAULT="[39m"
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
        printf "%s\n" "${BOLD}${BLUE}==> ${DEFAULT}${1}${RESET}"
    else
        printf_error "No msg provided, args: ${*}"
    fi
}

# UI
function prompt_to_continue() {
    if [[ -z "${ZSH_VERSION}" ]]; then
        read -p "${BLUE}${1:-Continue?} (y)es ${RESET}" -n 1 -r
    else
        read -kr "REPLY?${BLUE}${1:-Continue?} (y)es ${RESET}"
    fi

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        printf "\n\n"
        return 0
    else
        printf "\n%s\n\n" "${BLUE}${2:-Ok, exiting.}${RESET}"
        [[ $0 == "$0" ]] && exit 3 || return 3
    fi
}

# Helpers
function parse_opts() {
    local options="$1"
    local long_options="$2"
    local script_name="$3"
    local script_args=("${@:4}")
    local parsed

    getopt --test >/dev/null

    if [[ $? -ne 4 ]]; then
        printf_error "\`getopt --test\` failed in this environment."
        return 1
    fi

    if ! parsed=$(getopt --options="${options}" --longoptions="${long_options}" --name "${script_name}" -- "${script_args[@]}"); then
        printf_error "getopt parsing error"
        return 2
    fi

    printf "%s\n" "${parsed}"
}

function safe_source() {
    local help_msg=(
        "USAGE      safe_source <FILE>"
        ""
        "SYSNOPSIS      Check if FILE exists before attempting to source it."
        ""
        "OPTIONS"
        "               -h, --help  Show this help message."
    )

    case ${1:-} in
    -h | --help)
        printf "%s\n" "${help_msg[@]}"
        return 0
        ;;
    "")
        printf_error "Missing FILE argument."
        printf "%s\n" "" "${help_msg[@]}"
        return 0
        ;;
    esac

    if [[ -f "${1}" ]]; then
        source "${1}"
    fi
}

# Utils
function add_to_path() {
    local help_msg

    help_msg="Usage: add_to_path <prepend|append> <path> [path]..."

    local position="${1}"
    shift
    local paths=("$@")

    if [[ "$#" -eq 0 ]]; then
        printf_error "${help_msg}"
        return 1
    fi

if [[ -n "${ZSH_VERSION:-}" ]]; then
    case "${position}" in
    prepend)
        for new_path in "${paths[@]}"; do
            if [[ ! ${PATH} == *${new_path}* ]]; then
                export PATH="${new_path}:${PATH}"
            fi
        done
        ;;
    append)
        for new_path in "${paths[@]}"; do
            if [[ ! ${PATH} == *${new_path}* ]]; then
                export PATH="${PATH}:${new_path}"
            fi
        done
        ;;
    *)
        echo 2
        printf_error "${help_msg}"
        return 1
        ;;
    esac
else
    case "${position}" in
    prepend)
        for new_path in "${paths[@]}"; do
            if [[ ! "${PATH}" =~ ${new_path} ]]; then
                export PATH="${new_path}:${PATH}"
            fi
        done
        ;;
    append)
        for new_path in "${paths[@]}"; do
            if [[ ! "${PATH}" =~ ${new_path} ]]; then
                export PATH="${PATH}:${new_path}"
            fi
        done
        ;;
    *)
        echo 2
        printf_error "${help_msg}"
        return 1
        ;;
    esac
fi
}

function join() {
    local IFS=$1
    __="${*:2}"
    printf "%s" "${__}"
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

function egrep() {
    grep --extended-regexp "$@"
}
