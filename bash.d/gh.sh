# shellcheck shell=bash

function ghpr() {
    local title
    local main_sha
    local base
    local args=()
    local tmpdir

    tmpdir="$(mktemp -d)"
    local tmpfile="${tmpdir}/body"

    glc --print >"${tmpfile}"

    title="$(git log -1 --format="%s")"
    main_sha="$(git rev-parse "$(__git_master_or_main)")"
    base="$(git for-each-ref \
        --sort=-committerdate \
        --format "%(refname:short)" \
        --contains "${main_sha}" \
        refs/remotes/origin/ |
        grep -e "^origin/.*" |
        tail -n +2 |
        head -1)"

    if [[ -n "${CODEOWNERS:-}" ]]; then
        args+=("--assignee" "${CODEOWNERS}")
    fi

    args=(
        "--title"
        "'${title}'"
        "--body-file"
        "'${tmpfile}'"
        "--base"
        "'${base}'"
    )

    if [[ "${1:-}" == "--check" || "${1:-}" == "-c" ]]; then
        printf "%s\n" "gh pr create ${args[*]}"
    else
        gh pr create "${args[@]}"
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
