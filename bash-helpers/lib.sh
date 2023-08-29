# shellcheck disable=SC1090,SC1091,SC2034  # SC2034: ignore globals that are set for use elsewhere
if [[ ${DEBUG:-} -eq 1 ]]; then
    source "${HOME}/.dotfiles/lib/log.sh"
else
    function log() {
        true
    }
fi

# Declare this before usage
function printf_callout() {
    printf "%s\n" "$(tput bold)==> ${1}$(tput sgr0)"
}

log debug ""
log debug "$(printf_callout ["${BASH_SOURCE[0]}"])"

log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading printing helpers..."

# Colors
BLACK=$(tput setaf 0)
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

export BLACK
export RED
export GREEN
export YELLOW
export BLUE
export MAGENTA
export CYAN
export WHITE
export BOLD
export RESET

# Output formatting
function indent_output() {
    local indent_size=4
    local indent_levels=1

    if [[ ${1:-} =~ ^[1-9]+ ]]; then
        indent_levels=$1
    fi

    pr --omit-header --indent $((indent_levels * indent_size))
}

function printf_callout() {
    printf "%s\n" "${BOLD}==> ${1}${RESET}"
}

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
    log trace "[$(basename "${BASH_SOURCE[0]}")]: add_to_path | args: $*"

    local position="$1"
    local new_path
    new_path="$(printf "%s" "$2" | trim)"

    if [[ ! -d ${new_path} ]]; then
        printf_error "ERROR: ${new_path} is not a directory"
        [[ $0 == "${BASH_SOURCE[0]}" ]] && exit 1 || return 1
    fi

    if [[ ! ":${PATH}:" =~ :${new_path}: ]]; then
        case "${position}" in
        prepend)
            log debug "[$(basename "${BASH_SOURCE[0]}")]: Prepending ${new_path} to ${PATH}..."
            export PATH="${new_path}:${PATH}"
            ;;
        append)
            log debug "[$(basename "${BASH_SOURCE[0]}")]: Appending ${new_path} to ${PATH}..."
            export PATH="${PATH}:${new_path}"
            ;;
        *)
            printf_error "ERROR: position argument missing" "USAGE: add_to_path <prepend|append> <path>"
            ;;
        esac
    fi
}

function join() {
    local IFS=$1
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
