# lib.sh
logger "" "[${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  User interface
# ------------------------------------------------
logger "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

function printf_callout() {
    printf "%s\n" "==> $1"
}

function indent_output() {
    local indent

    if [[ $1 =~ ^[0-9]+ ]]; then
        indent="$(seq "$1" | sed -E 's/.+/    /')"
    else
        indent="    "
    fi

    sed "s/^/${indent}/"
}

# Headers
function print_header() {
    printf "\n%b\n" "\x1b[1m==> ${*}\x1b[0m"
}

function reset() {
    "\x1b[0m"
}

# Colors
function green() {
    "\x1b[32;01m${*}\x1b[0m"
}

function yellow() {
    "\x1b[33;01m${*}\x1b[0m"
}

function red() {
    "\x1b[33;31m${*}\x1b[0m"
}
