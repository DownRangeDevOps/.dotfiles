# shellcheck shell=bash

function gh_pr() {
    local origin_base_branch
    local local_base_branch
    local first_commit_subject
    local pr_title
    local args
    local git_push_cmd

    git fetch --prune

    git push "$(git config --default origin --get clone.defaultRemoteName)" \
        --set-upstream \
        --force-with-lease \
        HEAD

    git fetch --prune

    printf "\n"
    printf_callout "Setting the origin base branch."
    origin_base_branch=$(git_get_branch_base_ref)
    printf "%s\n\n" "Origin base branch: ${origin_base_branch}" | indent_output

    printf_callout "Setting the local base branch."
    local_base_branch=$(sed -E "s,^origin/,," <<< "${origin_base_branch}")
    printf "%s\n\n" "Local base branch: ${local_base_branch}" | indent_output

    printf_callout "Getting subject of the first commit of this branch."
    first_commit_subject="$(git log --reverse --format='%s' "${origin_base_branch}..HEAD" | head -1)"

    printf_callout "Creating the PR title."
    pr_title=$(sed -E "s/\[\[/[/" <<<"${first_commit_subject}" | sed -E "s/\]\]/]/")
    printf "%s\n\n" "PR title: ${pr_title}" | indent_output

    pr_body_file="$(mktemp -p /tmp)"

    printf_callout "Outputting PR body content to tempfile."
    git_log_copy --print >| "${pr_body_file}"
    printf "%s\n" "PR body:" | indent_output
    indent_output < "${pr_body_file}"
    printf "\n"

    args=(
        "--title"
        "${pr_title}"
        "--body-file"
        "${pr_body_file}"
    )

    if [[ "$(gh_check_for_pr)" == "true" ]]; then
        printf "\n"
        printf_callout "Updating pull request..."
        gh pr edit "${args[@]}"
    else
        printf "\n"
        printf_callout "Creating pull request..."

        args+=(
            "--base"
            "${local_base_branch}"
        )

        gh pr create "${args[@]}"
    fi

    rm -f "${pr_body_file}"
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
