#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091
#
# Name:
#        git-parse-repos.sh - Parse and optionally act on all git repositories
#        in [DIR] and subdirectories of it.
#
# Usage: git-parse-repos.sh [DIR]
#        git-parse-repos.sh [-comd] [--gc] [--dry-run] [DIR]
#        git-parse-repos.sh [--committer <ARG> --output <FILE> --mailmap <FILE>] [--gc | --debug --dry-run] [DIR]
#        git-parse-repos.sh (--help | --debug | --version)
#
# Description:
#        Parse and optionally act on all git repositories in [DIR] and
#        subdirectories of it. Output information about each repository.
#        Management options allow actions to be taken against each repository.
#
# Options:
#        -c, --committer ARG  Comitter to filter by, uses ripgrep with --smart-case
#        -o, --output FILE    Output file
#        -m, --mailmap FILE   Path to .mailmap file to add to each repository
#        --dry-run            Run without making any changes or creating any files
#        --gc                 Run `git gc --aggressive --prune=now` on each
#                             repository
#        -d, --debug          Output debug information
#        -h, --help           Show this help message and exit
#        -v, --version        Show version

# libs
SCRIPT_PATH="$(dirname "$0")"
PATH="${PATH}:${SCRIPT_PATH}/../bin"

source "${SCRIPT_PATH}/../bash-helpers/lib.sh"

# globals
DEPENDENCIES=(fd git rg gh trim)
VERSION=0.1.0

# init
source "${SCRIPT_PATH}/../bin/docopts.sh" --auto "$@"

function check_dependencies() {
    MISSING_DEPS=()
    printf_callout "Checking dependencies:"

    for dep in "${DEPENDENCIES[@]}"; do
        if ! command -v "${dep}" > /dev/null; then
            printf_error "${dep}... MISSING" | indent_output
            MISSING_DEPS+=("${dep}")
        else
            printf_success "${dep}... AVAILABLE" | indent_output
        fi
    done

    printf_success "    DONE"
    printf "\n"
}

function parse_args() {
    if [[ -n "${ARGS[--mailmap]}" ]]; then
        ARGS[--mailmap]=$(realpath "${ARGS[--mailmap]}")
    fi

    if [[ "${ARGS[--output]}" ]]; then
        ARGS[--output]=$(realpath "${ARGS[--output]}")
    fi
}

function find_repos() {
    REPOS_ABS_PATHS=()

    printf_callout "Finding repositories..."

    mapfile -t FOUND_REPOS < <(fd --type d --hidden --full-path --glob "**/.git" "${ARGS[DIR]}")

    for path in "${FOUND_REPOS[@]}"; do
        REPOS_ABS_PATHS+=("$(realpath "${path/\/.git/}")")
    done


    printf_success "    DONE"
    printf "\n"
}

function output() {
    local committers="${query_results[committers]}"
    local remote="${query_results[remote]}"
    local branch="${query_results[branch]}"
    local status="${query_results[status]}"
    local printf_status="${query_results[printf_status]}"
    local repo_path="${query_results[repo_path]}"

    printf_callout "Repoistory details:"
    printf "%s\n" \
        "Remote: ${remote}" \
        "Branch: ${branch/origin\//}" \
        "Status: ${printf_status}" \
        "Path: ${repo_path}" \
        "Comitters:" \
        "${committers}" | indent_output "$@"

    if [[ -n ${ARGS[--output]} ]] && ! ${ARGS[--dry-run]}; then
        printf_callout "Saving output to $(printf_green "${ARGS[--output]}")${BOLD}..."
        printf "%s\n" \
            "Remote: ${remote}" \
            "Branch: ${branch/origin\//}" \
            "Status: ${status}" \
            "Path: ${repo_path}" \
            "Comitters:" \
            "${committers}" \
            "" >> "${ARGS[--output]}"
    fi

    printf "\n"
}

function parse_repos() {
    declare -A query_results

    for path in "${REPOS_ABS_PATHS[@]}"; do
        printf_callout "Quering $(printf_green "${path}")${BOLD} ..."
        query_results[repo_path]="${path}"

        (
            cd "${path}" || exit 1

            query_results[committers]="$(git shortlog -sne HEAD 2>/dev/null | trim)"
            query_results[status]=$(git status --short)
            query_results[remote]=$(git remote -v | head -1 | cut -f 2 | cut -f 1 -d ' ')
            query_results[branch]=$(git rev-parse --abbrev-ref origin/HEAD 2>/dev/null)

            if [[ -z "${query_results[remote]}" ]]; then query_results[remote]="none"; fi
            if [[ -z "${query_results[branch]}" ]]; then query_results[branch]="none"; fi

            if [[ -n "${query_results[status]}" ]]; then
                query_results[status]="dirty"
                query_results[printf_status]="$(printf_red dirty)"
            else
                query_results[status]="clean"
                query_results[printf_status]="clean"
            fi

            if [[ -n ${ARGS[--committer]} ]]; then
                if printf "%s" "${query_results[committers]}" \
                    | rg --no-config --smart-case --quiet "${ARGS[--committer]}"; then

                    exec_repo_git_actions
                    output query_results
                fi
            else
                    exec_repo_git_actions
                    output query_results
            fi
        )
    done
}

function exec_repo_git_actions() {
    if ! ${ARGS[--dry-run]}; then
        if ${ARGS[--gc]}; then
            printf_callout "Running git gc --aggressive --prune=now..."
            git gc --aggressive --prune=now
        fi

        if [[ -n ${ARGS[--mailmap]} ]]; then
            printf_callout "Adding .mailmap..."
            cp -f "${ARGS[--mailmap]}" ./.mailmap
        fi
    fi
}

function main() {
    if ${ARGS[--debug]}; then
        printf_callout "Debugging mode enabled..."
        printf "\n"

        printf_callout "ARGS:"

        for arg in "${!ARGS[@]}" ; do
            if ${ARGS[$arg]}; then
                echo "    $arg = ${ARGS[$arg]}"
            else
                echo "    $arg = ${ARGS[$arg]}"
            fi
        done

        printf "\n"

        check_dependencies
    elif ${ARGS[--version]}; then
        printf "%s\n" "${VERSION}"
    else
        if [[ -n ${ARGS[DIR]} ]]; then
            printf_callout "Using directory: $(printf_green "${ARGS[DIR]} w")..."
        else
            printf_callout "No directory specified, using current directory..."
            ARGS[DIR]="./"
        fi

        local dep_check_msg
        dep_check_msg=$(check_dependencies)

        if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
            printf_error "Missing dependencies..."
            printf "%s\n" "${dep_check_msg}"
            printf_callout "Please install $(printf_red "${MISSING_DEPS[*]}") and try again..."
            printf_callout "Exiting..."
            exit 1
        fi

        parse_args

        if [[ -n ${ARGS[--output]} ]]; then
            printf_callout "Truncating $(printf_green "${ARGS[--output]}")${BOLD} ..."
            true > "${ARGS[--output]}"
        fi

        find_repos
        parse_repos
        printf_success "    DONE"
    fi
}

# for arg in "${!ARGS[@]}" ; do
#     echo "    $arg = ${ARGS[$arg]}"
# done

main
