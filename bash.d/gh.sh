# shellcheck shell=bash

function ghpr() {
    local options="uc"
    local long_options="update,check"
    local title
    local base
    local base_args=()
    local args=()
    local tmpfile
    local check

    tmpfile="$(mktemp)"

    glc --print >|"${tmpfile}"

    base=$(git_get_branch_base_ref | sed -E "s/^origin\///")
    title="$(git log --reverse --format='%s' "${base}"..HEAD | head -1)"
    echo $title

    if [[ -n "${CODEOWNERS:-}" ]]; then
        args+=("--add-assignee" "${CODEOWNERS}")
    fi

    base_args=(
        "--title"
        "'${title}'"
        "--body-file"
        "${tmpfile}"
        "--base"
        "${base}"
    )

    if [[ $# -ne 0 ]]; then
        # Parse options
        parsed=$(parse_opts "${options}" "${long_options}" "$0" "$@")
        eval set -- "${parsed}"

        while true; do
            case "${1:-}" in
            -u | --update)
                args=("pr" "edit" "${base_args[@]}")
                shift
                ;;
            -c | --check)
                check="true"
                args=(
                    "Body:"
                    "$(<"${tmpfile}")"
                    ""
                    "Command:"
                    "${base_args[*]}"
                )
                shift
                ;;
            --)
                shift
                break
                ;;
            *)
                printf_error "Unknown option: ${1}"
                break
                ;;
            esac
        done
    else
        args=("pr" "create" "${base_args[@]}")
    fi

    if [[ -n ${check:-} ]]; then
        printf "%s\n" "${args[@]}"
    else
        gh "${args[@]}"
    fi

    rm -rf "${tmpfile}"
}

# function gh() {
#     if [[ "${1}" == "pr" && "${2}" == create ]]; then
#         title="$(git log -1 --format="%s" "origin/$(__git_master_or_main)..head")"
#         body="$(git log --format="## %s (%h)%n% n%b" "origin/$(__git_master_or_main)..head")"
#         args=(
#             "--title"
#             "${title}"
#             "--body"
#             "${body}"
#         )
#
#         gh pr create "${args[@]}" "$@"
#     else
#         gh "$@"
#     fi
# }

# vim: set ft=zsh
