#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091

source ~/.dotfiles/bash-helpers/lib.sh
source ~/.dotfiles/bash-helpers/git.sh

if [[ $# -lt 3 ]] && [[ ! -f ${3} ]]; then
    printf_error "$(printf "Usage: %s <cmd> <repos_file>\n" "${0}")"
    exit 1
fi

GH_ORG=DRDO-Archive
ORG_NAME=$2
mapfile -t REPOS < "$3"
mapfile -t GH_ARGS <<'EOF'
--disable-issues
--disable-wiki
--private
--push
EOF


for path in "${REPOS[@]}"; do
    REPO_BASE_NAME="$(basename "${path}")"
    REPO_CLEAN_NAME=$(printf "%s" "${REPO_BASE_NAME}" | sed -E "s/-?${ORG_NAME}-?//g")
    REPO_FINAL_NAME="${GH_ORG}/${ORG_NAME}-${REPO_CLEAN_NAME}"
    path="$(realpath "${path}")"

    case "${1}" in
        show-large-files )
            printf_callout "${path}"
            (cd "${path}" || exit 1
                git rev-list --objects --all \
                    | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
                    | sed -n 's/^blob //p' \
                    | sort --numeric-sort --key=2 \
                    | cut -c 1-12,41- \
                    | $(command -v gnumfmt || echo numfmt) \
                        --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest \
                    | tail -n 20
            )
            printf "\n"
            ;;
        mail-map )
            printf_callout "Adding mailmap (${REPO_FINAL_NAME})"
            (cd "${path}" || exit 1
                printf "%s" "    "
                if ! git checkout master 2>/dev/null; then
                    git checkout main
                fi

                indent_output "$(git branch -D mailmap 2>/dev/null)"
                indent_output "$(git checkout -b mailmap)"
                cp -f ~/.dotfiles/config/git/.git-template/.mailmap "${path}/.mailmap"
                indent_output "$(git add ".mailmap")"
                indent_output "$(git commit -m "Add mailmap")"
                indent_output "$(git checkout - )"
                indent_output "$(git merge --no-ff mailmap)"
            )
            printf "\n"
            ;;
        filter-repo-mailmap )
            printf_callout "Editing repo to apply mailmap (${REPO_FINAL_NAME})"
            (cd "${path}" || exit 1
                indent_output "$(git filter-repo --force --use-mailmap)"
            )
            printf "\n"
            ;;
        push-all )
            printf_callout "Force pushing all to GitHub (${REPO_FINAL_NAME})"
            (cd "${path}" || exit 1
                git remote remove origin 2>/dev/null
                indent_output 2 "$(git remote add origin "git@github.com:${REPO_FINAL_NAME}.git")"
                indent_output "$(git push --all --force)"
            )
            printf "\n"
            ;;
        gh )
            printf_callout "${path}"
            # if prompt_to_continue "No to skip, CTRL+C to abort" "Skipping..."; then
                (cd "${path}" || exit 1
                    if [[ ! -f ${path}/.mailmap ]]; then
                        indent_output "$(printf_callout "Adding mailmap (${REPO_FINAL_NAME})")"
                        cp ~/.dotfiles/config/git/.git-template/.mailmap .
                        indent_output 2 "$(git checkout -b mailmap)"
                        indent_output 2 "$(git add --all)"
                        indent_output 2 "$(git commit -m "Add mailmap")"
                    fi

                    indent_output "$(printf_callout "Adding remote origin (${REPO_FINAL_NAME})")"
                    git remote remove origin 2>/dev/null
                    indent_output 2 "$(git remote add origin "git@github.com:${REPO_FINAL_NAME}.git")"

                    # if ! gh repos view "${REPO_FINAL_NAME}" &>/dev/null; then
                        indent_output "$(printf_callout "Creating GitHub repository (${REPO_FINAL_NAME}))")"
                        indent_output 2 "$(gh repo create "${REPO_FINAL_NAME}" "${GH_ARGS[@]}" --source "${path}")"
                    # fi

                    indent_output "$(printf_callout "Pushing to GitHub (${REPO_FINAL_NAME}))")"
                    indent_output 2 "$(git push --all --force origin)"
                )
            # fi
            printf "\n"
            ;;
        show-final-repo-names )
            printf_callout "${REPO_FINAL_NAME}"
            ;;
        * )
            printf_error "Unknown command: ${1}"
    esac
done
