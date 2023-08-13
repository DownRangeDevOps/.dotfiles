#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091
# Usage: setup.sh [options]
#
# Options:
#     --dry-run      Output commands that would be run, but do not execute them
#     --debug        Output debug information
#     -v, --version  Show version
#     -h, --help     Show this help message and exit
set -e

# setup docopts
PATH="${PATH}:./bin"
source docopts.sh
HELP=$(docopt_get_help_string "$0")
VERSION="0.1.0"
OPTIONS=$(docopts -h "${HELP}" -V "${VERSION}" : "$@")

# dummy vars to please shellcheck
debug=false
dry_run=false

# set docopts options
eval "${OPTIONS}"

function print_error_msg() {
    MSG_TYPE="$1"
    NOT_REPO_MSG="${HOME}/.dotfiles exists and is not a git repo"
    CHANGES_MSG="${HOME}/.dotfiles has uncommitted changes, stash or commit them then re-run setup."

    if [[ -n ${MSG_TYPE} ]]; then
        case ${MSG_TYPE} in
            not_repo)
                printf "%s\n" "${NOT_REPO_MSG}"
                ;;
            changes)
                printf "%s\n" "${CHANGES_MSG}"
                ;;
            *)
                printf "%s\n" "ERROR: ${*}"
                ;;
        esac
    else
        printf "%s\n" "ERROR: unknown error"
    fi
}

function create_symlinks() {
    if ${dry_run}; then
        printf "\n%s\n" "Symlinks that would be created:"

        find "${HOME}/.dotfiles/config" -type f -exec bash -c \
            'file="$1";printf "%s\n" "\"${HOME}/$(basename ${file})\" -> \"${PWD}/${file}\""' \
            shell {} \;
    else
        find "${HOME}/.dotfiles/config" -type f -iname ".*" -exec bash -c \
            'file="$1"; ln -sfv "${file}" "${HOME}/$(basename ${file})"' \
            shell {} \;
    fi
}

function init() {
    if $dry_run; then
        printf "%s\n" "source ${HOME}/.bash_profile"
    else
        create_symlinks

        # shellcheck disable=SC1090,SC1091
        source "${HOME}/.bash_profile"
    fi
}

function setup() {
    if $dry_run; then
        printf "%s\n" "Commands that would be run:"

        is_git_repo="$(git -C "${HOME}/.dotfiles" rev-parse --is-inside-work-tree 2>/dev/null)"

        if ${is_git_repo}; then
            if [[ -z "$(git diff --name-only)" ]]; then
                printf "%s\n" "git -C ${HOME}/.dotfiles checkout main"
                printf "%s\n" "git -C ${HOME}/.dotfiles pull"
                printf "%s\n" "git -C ${HOME}/.dotfiles checkout -"

                init
                create_symlinks
            else
                print_error_msg changes
                return 1
            fi
        else
            print_error_msg not_repo
            return 1
        fi
    else
        is_git_repo="$(git -C "${HOME}/.dotfiles" rev-parse --is-inside-work-tree 2>/dev/null)"

        if ${is_git_repo}; then
            if [[ -z "$(git diff --name-only)" ]]; then
                git -C "${HOME}/.dotfiles" checkout main
                git -C "${HOME}/.dotfiles" pull
                git -C "${HOME}/.dotfiles" checkout -

                create_symlinks
                init
            else
                print_error_msg changes
                return 1
            fi
        else
            print_error_msg not_repo
            return 1
        fi
    fi
}

if ${debug}; then
    printf  "%s\n" "$OPTIONS"
else
    setup
fi
