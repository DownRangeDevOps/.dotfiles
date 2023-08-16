# lib.sh
logger "" "[${BASH_SOURCE[0]}]"

# ------------------------------------------------
# Printing
# ------------------------------------------------
logger "[$(basename "${BASH_SOURCE[0]}")]: Loading printing helpers..."

# Formatting
function indent_output() {
    local indent

    if [[ $1 =~ ^[0-9]+ ]]; then
        indent="$(seq "$1" | sed -E 's/.+/    /')"
    else
        indent="    "
    fi

    sed "s/^/${indent}/"
}

function printf_callout() {
    printf "%s\n" "==> $1"
}

function printf_header() {
    printf "\n%b\n" "\033[1m==> ${*}\033[0m"
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

function printf_green() {
    printf "%b\n" "${GREEN}${*}${RESET}"
}

function printf_yellow() {
    printf "%b\n" "${YELLOW}${*}${RESET}"
}

function printf_red() {
    printf "%b\n" "${RED}${*}${RESET}"

}
