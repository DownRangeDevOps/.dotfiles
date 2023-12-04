# shellcheck shell=bash

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
