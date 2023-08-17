#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091
# Usage: git-parse-repos.sh [-corhv] [--gc]
#        git-parse-repos.sh --help
#        git-parse-repos.sh --debug
#
# Options:
#     -c, --committer  Comitter to filter by
#     -o, --output     Output file
#     -r, --root       Directory to start searching from
#     --gc             Run `git gc --aggressive --prune=now` on each repository
#
#     --debug          Output debug information
#     -h, --help       Show this help message and exit
#     -v, --version    Show version

PATH="${PATH}:./bin"

source ../bin/docopts.sh
source ../bash-helpers/lib.sh

# setup docopts
DEPENDENCIES=(fd git rg)
HELP=$(docopt_get_help_string "$0")
VERSION="0.1.0"


# init options to please linters
committer=
debug=
gc=
output_file=
root=

# parse arguments
OPTIONS=$(../bin/docopts -h "${HELP}" -V "${VERSION}" : "$@")

function check_dependencies() {
    printf "%s\n" "Checking dependencies:"

    for dep in "${DEPENDENCIES[@]}"; do
        if ! command -v "${dep}" &>/dev/null; then
            printf_error "${dep}... MISSING"
            MISSING_DEPS=true
        else
            printf_success "${dep}... AVAILABLE"
        fi
    done
}

function find_repos() {
    mapfile -t PATHS "$(fd --type d --hidden --full-path --glob '**/.git' "${root:.}")"
}

function output() {
    local committers="${1[committers]}"
    local remote="${1[remote]}"
    local branch="${1[branch]}"
    local status="${1[status]}"
    local status_print="${1[status_print]}"
    local repo_path="${1[repo_path]}"

    printf "%s\n" \
        "Remote: ${remote}" \
        "Branch: ${branch/origin\//}" \
        "Status: ${status_print}" \
        "Path: ${repo_path}" \
        "Comitters:" \
        "${committers}"

    if [[ -n "${output_file}" ]]; then
        printf "%s\n" \
            "Remote: ${remote}" \
            "Branch: ${branch/origin\//}" \
            "Status: ${status}" \
            "Path: ${repo_path}" \
            "Comitters:" \
            "${committers}" \
            "" >> "${output_file}"
    fi

    printf "\n"
}

function parse_repos() {
    local args
    declare -A args

    for repo in "${PATHS[@]}"; do
        args[repo_path]="${repo/\/.git/}"

        printf_callout "Quering $(printf_green "${args[repo_path]}")${BOLD} ..."

        (
            cd "${PWD}/${args[repo_path]}" || exit 1

            if ${gc}; then
                git gc --aggressive --prune=now
            fi

            args[committers]="$(git shortlog -sne HEAD 2>/dev/null | ../utils/trim.sh)"
            args[status]=$(git status --short)
            args[remote]=$(git remote -v | head -1 | cut -f 2 | cut -f 1 -d ' ')
            args[branch]=$(git rev-parse --abbrev-ref origin/HEAD 2>/dev/null)

            if [[ -z "${args[remote]}" ]]; then args[remote]="none"; fi
            if [[ -z "${args[branch]}" ]]; then args[branch]="none"; fi

            if [[ -n "${args[status]}" ]]; then
                args[status]="dirty"
                args[status_print]="$(printf_red dirty)"
            else
                args[status]="clean"
                args[status_print]="clean"
            fi

            if printf "%s" "${args[committers]}" | rg --no-config --smart-case --quiet "${args[committer]}"; then
                output args
            fi
        )
    done
}

function main() {
    if ${debug}; then
        printf "%s\n" "Options:"
        indent_output "${OPTIONS}"

        printf "\n"
        check_dependencies
        exit 0
    fi

    if "${MISSING_DEPS}"; then
        exit 1
    fi

    if [[ -n ${output_file} ]]; then
        true > "${output_file}"
    fi

    find_repos
    parse_repos
}


main
