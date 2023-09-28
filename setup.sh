#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091,SC2119  # SC2119: Ignore passing "$@" to `indent_output`
# Usage: setup.sh [options]
#
# Options:
#     --dry-run      Output commands that would be run, but do not execute them
#     --debug        Output debug information
#     -v, --version  Show version
#     -h, --help     Show this help message and exit
set -uo pipefail;

# defaults
debug=false
dry_run=false

source bash-helpers/lib.sh

if command -v docopts; then
    PATH="${PATH}:./bin"
    source docopts.sh

    HELP=$(docopt_get_help_string "$0")
    VERSION="0.1.0"
    OPTIONS=$(docopts -h "${HELP}" -V "${VERSION}" : "$@")

    eval "${OPTIONS}"
fi


function print_error_msg() {
    if [[ -n ${1:-} ]]; then
        case $1 in
            not_repo)
                printf_error "${HOME}/.dotfiles exists and is not a git repo"
                ;;
            changes)
                printf_error "${HOME}/.dotfiles has uncommitted changes, stash or commit them then re-run setup."
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
    (cd "${HOME}" || exit 1
        ln -sfvr "${HOME}/.config/nvim" nvim
        ln -sfvr "${HOME}/.config/.terminfo" .terminfo
    )
}

function symlink_dotfiles() {
    local dotfile_paths

    dotfile_paths=$(find "${HOME}/.dotfiles/config" -maxdepth 1 -type f -iname ".*")

    printf_callout "Creating symlinks..."

    for file in ${dotfile_paths}; do
        if ${dry_run}; then
            printf "%s\n" "${HOME}/$(basename "${file}") -> ${PWD}/${file}" | indent_output
        else
            ln -sfvr "${file}" "${HOME}/$(basename "${file}")" | indent_output
        fi
    done

    printf "\n"
}

function init() {
    local init_cmd="source ${HOME}/.bash_profile"

    printf_callout "Initalizing shell..."

    if $dry_run; then
        printf "%s\n" "${init_cmd}" | indent_output
    else
        printf "%s\n" "${init_cmd}" | indent_output
        source "${init_cmd}"
    fi

    printf "\n"
}

function setup() {
    if $dry_run; then
        printf_callout "Running in 'dry-run' mode..."
        printf "\n"
    fi

    if ! git -C "${HOME}/.dotfiles" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        print_error_msg not_repo
        return 1
    fi

    printf_callout "Installing dotfiles..."

    if [[ -z "$(git diff --name-only)" ]]; then
        symlink_config_dirs
        symlink_dotfiles
        init
    else
        print_error_msg changes
        return 1
    fi
}

if ${debug}; then
    printf  "%s\n" "$OPTIONS"
else
    setup
fi
