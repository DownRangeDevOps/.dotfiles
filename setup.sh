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

source bash-helpers/lib.sh

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

function create_symlinks() {
    local gitignore_path="${HOME}/.dotfiles/config/git/.gitignore"
    local init_vim_path="${HOME}/.config/nvim/init.vim"
    local terminfo_path="${HOME}/.config/.terminfo"

    printf_callout "Creating symlinks..."

    if ${dry_run}; then
        find "${HOME}/.dotfiles/config" -maxdepth 1 -type f -exec bash -c \
            'file="$1"; printf "%s\n" "\"${HOME}/$(basename ${file})\" -> \"${PWD}/${file}\""' \
            shell {} \; | indent_output

        printf "%s\n" \
            "\"${HOME}/.gitignore\" -> \"${gitignore_path}\"" \
            "\"${HOME}/.vimrc\" -> \"${init_vim_path}\"" \
            | indent_output
    else
        find "${HOME}/.dotfiles/config" -maxdepth 1 -type f -iname ".*" -exec bash -c \
            'file="$1"; ln -sfvr "${file}" "${HOME}/$(basename ${file})"' \
            shell {} \; | indent_output

            (cd "${HOME}" || exit 1
                ln -sfvr ${gitignore_path} .gitignore
                ln -sfvr ${init_vim_path} init.vim
                ln -sfvr ${terminfo_path} .terminfo
            )
    fi

    printf "\n"
}

function install_docopts() {
    local tmp_dir
    tmp_dir="$(mktemp --directory --tmpdir)"

    local docopts_install_cmd="
        go install
        github.com/docopt/docopt-go
        github.com/docopt/docopts
        "
    local docopts_sh_install_cmd="
        (cd ${tmp_dir} || exit 1 &&
            (
                curl -O https://raw.githubusercontent.com/docopt/docopts/master/docopts.sh;
                chmod + x docopts.sh;
                mv docopts.sh /usr/local/bin
            )
        )"

    if [[ ! -f bin/docopts ]]; then
        printf_callout "Installing docopts..."

       if $dry_run; then
            printf "%s\n" "${docopts_install_cmd}" | indent_output
        else
            (eval "${docopts_install_cmd}" | indent_output)
        fi

        printf "\n"
    else
        printf_callout "docopts already installed, skipping."
        printf "\n"
    fi

    if [[ ! -f bin/docopts.sh ]]; then
        printf_callout "Installing docopts.sh..."

        if $dry_run; then
            printf "%s\n" "${docopts_sh_install_cmd}" | indent_output
        else
            (eval "${docopts_sh_install_cmd}" | indent_output)
        fi

        printf "\n"
    else
        printf_callout "docopts.sh already installed, skipping."
        printf "\n"
    fi
}

function install_lazy_vim() {
    local lazy_vim_install_cmd="git clone git@github.com:DownRangeDevOps/LazyVim.git ~/.config/nvim"

    if [[ ! -d ~/.config/nvim ]]; then
        printf_callout "Installing LazyVim..."

        if $dry_run; then
            printf "%s\n" "${lazy_vim_install_cmd}" | indent_output
        else
            (eval "${lazy_vim_install_cmd}" | indent_output)
        fi

        printf "\n"
    else
        printf_callout "LazyVim already installed, skipping."
        printf "\n"
    fi
}

function init() {
    local init_cmd="source ${HOME}/.bash_profile"

    printf_callout "Initalizing shell..."

    if $dry_run; then
        printf "%s\n" "${init_cmd}" | indent_output
    else
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
        if $dry_run; then
            printf "%s\n" "git -C ${HOME}/.dotfiles checkout main" | indent_output
            printf "%s\n" "git -C ${HOME}/.dotfiles pull" | indent_output
            printf "%s\n" "git -C ${HOME}/.dotfiles checkout -" | indent_output
            printf "\n"
        else
            git -C "${HOME}/.dotfiles" checkout main | indent_output
            git -C "${HOME}/.dotfiles" pull | indent_output
            git -C "${HOME}/.dotfiles" checkout - | indent_output
            printf "\n"
        fi

        create_symlinks
        install_docopts
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
