#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091,SC2119  # SC2119: Ignore passing "$@" to `indent_output`
# Usage: setup.sh [options]
#
# Options:
#     --dry-run      Output commands that would be run, but do not execute them
#     --debug        Output debug information
#     -v, --version  Show version
#     -h, --help     Show this help message and exit
export PATH=./bin:${PATH}

if [[ ${BASH_VERSION:0:1} -lt 4 ]]; then
    printf "%b\n" "$(tput setaf 1)ERROR: Bash 4+ is required for these dotfiles$(tput sgr0)"
    printf "%s\n" "Bash version: ${BASH_VERSION}"
    printf "%s\n" "Bash major version: ${BASH_VERSION:0:1}"
    printf "%s\n" "Bash path: ${BASH}"
    printf "\n"
    printf "%s\n" "Please install Bash 4+ (brew install bash) and re-run setup."
    exit 0
fi

set -uo pipefail;

# defaults
debug=false
dry_run=false
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# settings
NVIM_CONF_DIR="${HOME}/.config/nvim"
TERMINFO_CONF_DIR="${HOME}/.config/.terminfo"
YAMLFMT_CONF_DIR="${HOME}/.config/yamlfmt"
YAMLLINT_CONF_DIR="${HOME}/.config/yamllint"

source "${SCRIPT_DIR}/bash.d/lib.sh"

if command -v docopts; then
    set +u
    source docopts.sh
    set -u

    HELP=$(docopt_get_help_string "$0")
    VERSION="0.1.0"
    OPTIONS=$(docopts -h "${HELP}" -V "${VERSION}" : "$@")

    eval "${OPTIONS}"
fi

function print_error_msg() {
    if [[ -n ${1:-} ]]; then
        case $1 in
            not_repo)
                printf_error "${SCRIPT_DIR} exists and is not a git repo"
                ;;
            *)
                printf_error "ERROR: ${*}"
                ;;
        esac
    else
        printf_error "ERROR: unknown error"
    fi
}

function symlink_config_dirs() {
    printf_callout "Creating config symlinks..."

    if ${dry_run}; then
        (cd "${HOME}" || exit 1
            ln -sfv "${SCRIPT_DIR}/config/nvim" "${NVIM_CONF_DIR}" | indent_output
            ln -sfv "${SCRIPT_DIR}/config/.terminfo" "${TERMINFO_CONF_DIR}" | indent_output
            ln -sfv "${SCRIPT_DIR}/config/yamlfmt" "${YAMLFMT_CONF_DIR}" | indent_output
            ln -sfv "${SCRIPT_DIR}/config/yamllint" "${YAMLLINT_CONF_DIR}" | indent_output
        )
    else
        printf "%s\n" "${SCRIPT_DIR}/config/nvim -> ${NVIM_CONF_DIR}" | indent_output
        printf "%s\n" "${SCRIPT_DIR}/config/.terminfo -> ${TERMINFO_CONF_DIR}" | indent_output
        printf "%s\n" "${SCRIPT_DIR}/config/yamlfmt -> ${YAMLFMT_CONF_DIR}" | indent_output
        printf "%s\n" "${SCRIPT_DIR}/config/yamllint -> ${YAMLLINT_CONF_DIR}" | indent_output
    fi

    printf "\n"
}

function symlink_dotfiles() {
    local dotfile_paths
    local dotfiles_dir="${SCRIPT_DIR}/config"

    dotfile_paths=$(find "${dotfiles_dir}" -maxdepth 1 -type f -iname ".*" -print)

    printf_callout "Creating dotfile symlinks..."

    for file in ${dotfile_paths}; do
        if ${dry_run}; then
            printf "%s\n" "${HOME}/$(basename "${file}") -> ${dotfiles_dir}/${file}" | indent_output
        else
            ln -sfv "${file}" "${HOME}/$(basename "${file}")" | indent_output
        fi
    done

    printf "\n"
}

function symlink_bins() {
    local bin_paths
    local bin_dir="${SCRIPT_DIR}/bin"

    bin_paths=$(find "${bin_dir}" -maxdepth 1 -type f -print)

    printf_callout "Creating bin symlinks..."

    for file in ${bin_paths}; do
        if ${dry_run}; then
            printf "%s\n" "${HOME}/.local/bin/$(basename "${file}") -> ${bin_dir}/${file}" | indent_output
        else
            ln -sfv "${file}" "${HOME}/.local/bin/$(basename "${file}")" | indent_output
        fi
    done

    printf "\n"
}

function init_shell() {
    local init_file="${HOME}/.bash_profile"

    printf_callout "Initalizing shell..."

    if $dry_run; then
        printf "%s\n" "source ${init_file}" | indent_output
    else
        printf "%s\n" "source ${init_file}" | indent_output
        [[ -f "${init_file}" ]] && source "${init_file}"
    fi

    printf "\n"
}

function init() {
    init_shell
}

function setup() {
    if $dry_run; then
        printf "\n"
        printf_warning "Running in 'dry-run' mode..."
        printf "\n"
    fi

    if ! git -C "${SCRIPT_DIR}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        print_error_msg not_repo
        return 1
    fi

    printf "\n"
    printf_callout "Installing dotfiles..."

    symlink_dotfiles
    symlink_config_dirs
    symlink_bins
    init
}

if ${debug}; then
    printf  "%s\n" "$OPTIONS"
else
    setup
fi
