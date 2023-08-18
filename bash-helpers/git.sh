# git.sh
logger "" "[${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  Alises
# ------------------------------------------------
logger "[$(basename "${BASH_SOURCE[0]}")]: Loading aliases..."

# main
alias g="git"
alias gba="git branch --all"
alias gbn="git rev-parse --abbrev-ref HEAD"
alias gco="__git_checkout"
alias gcod="git checkout develop"
alias gcom="git checkout \$(__git_master_or_main)"
alias gd="__git_diff_so_fancy_with_less"
alias gd1="__git_diff_so_fancy_with_less HEAD~"
alias gdd="__git_diff_so_fancy_with_less origin/develop..."
alias gdm="__git_diff_so_fancy_with_less origin/master..."
alias gdmb="git_delete_merged_branches"
alias gf="git fetch --prune"
alias gfu="git_fixup"
alias gp="gf && git pull --rebase"
alias gs="git status"

# logging
alias gl="__git_log_branch"
alias gl-="__git_log_branch_no_trunc_msg"
alias gl--="__git_log_branch_only_msg"
alias gL="__git_log_all_branches"
alias gL-="__git_log_all_branches_no_trunc_msg"
alias gstat="__git_status_vs_master"
alias gstatd="__git_status_vs_develop"

# committing
alias ga.="git add --all"
alias ga="git add"
alias gab="git_absorb"
alias gc="pre-commit run --all-files && git add --update && git commit --no-verify --gpg-sign"
alias gcp="git cherry-pick -x"  # -x: add "cherry-picked from..." message
alias gqf="ga --update && gc --amend --no-edit && gfpo"
alias gst="git stash"

# rebasing
alias grb="git rebase --interactive --autosquash"
alias grba="git rebase --abort"
alias grbc="git rebase --continue"
alias grbd="gf && git rebase --interactive --autosquash origin/develop"
alias grbm="gf && git rebase --interactive --autosquash origin/\$(__git_master_or_main)"
alias grbs="gf && git rebase --interactive --autosquash \$(git merge-base HEAD origin/\$(__git_master_or_main))"

# Merging
alias gm="git_rebase_merge_and_push"
alias gmerged="__git_get_merged_branches"

# Pushing
alias gpu="git push --set-upstream \$(git remote) HEAD"
alias gfpo="git push --force-with-lease origin HEAD"

# Repository info
alias git-contributors="git shortlog --summary --email --numbered"

# ------------------------------------------------
#  Completion
# ------------------------------------------------
function __git_add_completion_to_aliases() {
    # Add git completion to aliases
    if declare -f -F __git_complete > /dev/null; then
        # checkout
        __git_complete __git_checkout _git_checkout
        __git_complete gcod _git_checkout
        __git_complete gcom _git_checkout

        # add
        __git_complete ga _git_add

        # branch
        __git_complete gb _git_branch

        # stash
        __git_complete gst _git_stash

        #rebase
        __git_complete grb _git_rebase
    fi
}
__git_add_completion_to_aliases

function __git_wrap_gffm() {
    # add git merge completion
    declare -f -F __git_func_wrap > /dev/null
    if [[ -n $? ]]; then
        __git_func_wrap _git_merge
    fi
}
complete -o bashdefault -o default -o nospace -F __git_wrap_gffm gffm

function __git_wrap_gnuke() {
    # add git checkout completion
    declare -f -F __git_func_wrap > /dev/null
    if [[ -n $? ]]; then
        __git_func_wrap _git_checkout
    fi
}
complete -o bashdefault -o default -o nospace -F __git_wrap_gnuke gnuke


# ------------------------------------------------
#  Private
# ------------------------------------------------
logger "[$(basename "${BASH_SOURCE[0]}")]: Loading private functions..."

function __git_is_repo() {
    if [[ -n ${1:-} ]]; then
        git -C "$1" rev-parse 2>/dev/null
    else
        git rev-parse 2>/dev/null
    fi
}

function __git_master_or_main() {
    local master_exists
    local main_exists
    local master_length
    local main_length
    local main_branch

    if ! __git_is_repo "${PWD}"; then
        printf_error "${PWD} is not a git repository!" >&2
        return 6
    fi

    if git show-ref --verify --quiet refs/heads/master; then master_exists=true; fi
    if git show-ref --verify --quiet refs/heads/main; then main_exists=true; fi

    if [[ -n ${master_exists:-} && -n ${main_exists:-} ]]; then
        master_length="$(git rev-list --count master)"
        main_length="$(git rev-list --count main)"

        if [[ ${master_length} -gt ${main_length} ]]; then
            main_branch="main"
        else
            main_branch="master"
        fi
    elif [[ -n ${main_exists:-} ]]; then
        main_branch="main"
    elif [[ -n ${master_exists:-} ]]; then
        main_branch="master"
    else
        printf_error "This repository does not have a 'master' or 'main' branch!" >&2
        return 6
    fi

    printf  "%s" "${main_branch}"
}

function __git_show_branch_state () {
    local branch
    local icon

    branch="$(git rev-parse --abbrev-ref HEAD)"
    icon="$(__git_parse_dirty)"

    printf "%s" "${branch}${icon}"
}

function __git_parse_dirty () {
    case $(git status 2>/dev/null) in
        *"Changes not staged for commit"*)
            printf "%s\n" " ${RED}✗";;
        *"Changes to be committed"*)
            printf "%s\n" " ${YELLOW}✗";;
        *"nothing to commit"*)
            printf "%s\n" " ${GREEN}✔︎";;
    esac
}

function __git_project_parent() {
    printf "%s" "$(git rev-parse --show-toplevel 2>/dev/null)/.."
}

function __git_project_root () {
    if [[ -n $(git branch 2>/dev/null) ]]; then
        printf "%s\n" "git@$(realpath --relative-to="$(__git_project_parent)" .)"
    else
        printf "%s\n" "${PWD/~/\~}"
    fi
}

function __git_status_vs_master() {
    printf  "%s\n" \
        "==> Log: " \
        "$(indent_output "$(git log "$(__git_master_or_main)..")")" \
        "" \
        "==> Diff:" \
        "$(indent_output "$(git diff --stat "$(__git_master_or_main)")")"
}

function __git_status_vs_develop() {
    if git show-ref --verify --quiet refs/heads/master; then
        printf  "%s\n" \
            "==> Log: " \
            "$(indent_output "$(git log origin/develop..)")" \
            "" \
            "==> Diff:" \
            "$(indent_output "$(git diff --stat origin/develop)")"
    else
        printf_error "The 'develop' branch does not exist!" >&2
        return 6
    fi
}

# diffing
function __git_diff_so_fancy_with_less() {
    git diff --color "${1:-@}" | diff-so-fancy | less --tabs=4 -RFX
}

# logging
function __git_log_branch() {
    git log \
        --graph \
        --color \
        --decorate=short \
        --format=format:'%C(bold blue)%h%C(reset) -%C(auto)%d%C(reset) %C(white)%<(50,trunc)%s%C(reset) %C(black)[%an]%C(reset) %C(bold green)(%ar)%C(reset)' \
        | LESS -SFX -R
}

function __git_log_branch_no_trunc_msg() {
    git log \
        --graph \
        --color \
        --decorate=short \
        --format=format:'%C(bold blue)%h%C(reset) -%C(auto)%d%C(reset) %C(white)%s%C(reset) %C(black)[%an]%C(reset) %C(bold green)(%ar)%C(reset)' \
        | LESS -SFX -R
}

function __git_log_branch_only_msg() {
    git log --color --format=format:'• %C(white)%s%C(reset)' | LESS -SFX -R
}

function __git_log_all_branches() {
git log \
    --branches \
    --remotes \
    --graph \
    --color \
    --decorate=short \
    --format=format:'%C(bold blue)%h%C(reset) -%C(auto)%d%C(reset) %C(white)%<(50,trunc)%s%C(reset) %C(black)[%an]%C(reset) %C(bold green)(%ar)%C(reset)' \
    | LESS -SFX -R
}

function __git_log_all_branches_no_trunc_msg() {
git log \
    --branches \
    --remotes \
    --graph \
    --color \
    --decorate=short \
    --format=format:'%C(bold blue)%h%C(reset) -%C(auto)%d%C(reset) %C(white)%s%C(reset) %C(black)[%an]%C(reset) %C(bold green)(%ar)%C(reset)' \
    | LESS -SFX -R
}

function __git_get_merged_branches() {
    git branch --all --merged "origin/$(__git_master_or_main)" \
        | rg --invert-match '>|master|main|develop|release' \
        | tr -d ' '
}

# ------------------------------------------------
#  Public
# ------------------------------------------------
logger "[$(basename "${BASH_SOURCE[0]}")]: Loading public functions..."

# Committing
function git_absorb() {
    git add -u
    git absorb --and-rebase "$@"
}

function git_fixup() {
    git add --update
    git log -n 50 --pretty=format:"%h %s" --no-merges \
        | fzf \
        | awk '{print $1}' \
        | xargs -o hub commit --fixup
    git rebase --interactive HEAD~2
}

# Branching
function gb() {
    if [[ ${1:-} == "-D" ]]; then
        git branch "${@}"
    else
        git branch "${@}"| fzf
    fi
}

function __git_checkout() {
    if [[ ${1:-} ]]; then
        git checkout "${@}"
    else
        git branch --all \
            | tr -d " " \
            | sed -e "s,^remotes/origin/,," \
            | sed -e "s,^HEAD.*,," \
            | sort -u \
            | fzf \
            | xargs git checkout
    fi
}

function git_delete_merged_branches() {
    REMOTES="${*:-origin}"
    printf_callout "Fetching updates..."
    git fetch --prune &>/dev/null
    git remote prune origin &>/dev/null

    CUR_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    LOCAL_BRANCHES=$(__git_get_merged_branches \
        | /usr/local/opt/grep/libexec/gnubin/grep -Ev "^\s*remotes/origin/" \
        | /usr/local/opt/grep/libexec/gnubin/grep -Ev "${CUR_BRANCH}" \
        | awk '{print $1}')
    REMOTE_BRANCHES=$(__git_get_merged_branches \
        | /usr/local/opt/grep/libexec/gnubin/grep -E "^\s*remotes/origin/" \
        | sed -e "s/^\s*remotes\/origin\///g" \
        | awk '{print $1}')

    if [[ -n ${LOCAL_BRANCHES} || -n ${REMOTE_BRANCHES} ]]; then
        printf_callout "Branches that have been merged to $(__git_master_or_main):"
        __git_get_merged_branches

        prompt_to_continue "Delete branches?" || return 0
        echo

        if [[ -n ${LOCAL_BRANCHES} ]]; then
            printf_callout "Deleting merged local branches..."
            git branch --delete --force ${LOCAL_BRANCHES}
        fi

        if [[ -n ${REMOTE_BRANCHES} ]]; then
            for REMOTE in ${REMOTES}; do
                printf_callout "Deleting merged remote branches from ${REMOTE}..."
                git push --delete "${REMOTE}" ${REMOTE_BRANCHES}
            done
        fi

        git fetch --prune &>/dev/null
        git remote prune origin &>/dev/null
        printf_callout "Merged branches have been deleted..."
        printf_callout "Everyone should run \`git fetch --prune\` to sync with this remote."
    else
        printf_callout "No merged branches to delete."
    fi
}

# Diff
function __git_diff_so_fancy_with_less() {
    git diff --color "${1:-@}" | diff-so-fancy | less --tabs=4 -RFX
}

# QOL
gcot() {
  TICKET=$(echo "${@}" \
    | tr -t "${@}" 50 \
    | sed "s/^[\.\/]//" \
    | tr -s " " "-" \
    | tr -cd "[:alnum:]._-/" \
    | tr "[:upper:]" "[:lower:]")

  __git_checkout -b "${TICKET}"
}

git_rebase_merge_and_push() {
    # git merge --ff-only
    local main_branch
    main_branch=$(__git_master_or_main)

    if [[ ${1:-} == "--ff-only" ]]; then
        MERGE_COMMIT_OPTION="--ff-only"
        shift
    else
        MERGE_COMMIT_OPTION="--no-ff"
    fi

    if [[ ${1:-} == "help" || ${1:-} == "--help" ]]; then
        print  "%s\n" \
            "Usage: gffm [OPTION] [<TARGET_BRANCH>]" \
            "Merge TARGET_BRANCH to ${main_branch} printing the log and stat, and" \
            "prompting before merging or pushing." \
            "" \
            "If no TARGET_BRANCH, or TARGET_BRANCH is HEAD, the current branch will be merged to ${main_branch}."
    else
        if [[ ${1:-} == "HEAD" || $1 == "" ]]; then
            git log "origin/${main_branch}.."
            git diff --stat "origin/${main_branch}"
            prompt_to_continue "Merge to ${main_branch}?"

            printf_callout "Updating from origin..."
            git fetch -p

            printf_callout "Rebasing onto ${main_branch}..."
            git checkout "${main_branch}"
            git pull -r
            git rebase "origin/${main_branch}"

            printf_callout "Merging to ${main_branch}..."

            if [[ $(git merge "${MERGE_COMMIT_OPTION}" "@{-1}") ]]; then
                git branch --delete "@{-1}"
                git push origin --delete "@{-1}"
            else
                printf "%b\n" "$(red ERROR: merge failed, exiting.)"
                return 1
            fi

            prompt_to_continue "Push to origin?"

            printf_callout "Pushing ${main_branch}..."
            git push origin HEAD
        else
            TARGET_BRANCH=$1
            git checkout "${TARGET_BRANCH}"

            printf_callout "Updating ${TARGET_BRANCH}..."
            git fetch -p
            git pull -r
            git checkout "@{-1}"
            git log "${TARGET_BRANCH}..@"
            git diff --stat "${TARGET_BRANCH}"
            prompt_to_continue "Merge to ${TARGET_BRANCH}?"

            printf_callout "Merging to ${TARGET_BRANCH}..."
            git rebase "${TARGET_BRANCH}"
            git checkout "${TARGET_BRANCH}"

            if [[ $(git merge "${MERGE_COMMIT_OPTION}" "@{-1}") ]]; then
                git branch --delete "@{-1}"
                git push origin --delete "@{-1}"
            fi

            prompt_to_continue "Push to origin?"

            printf_callout "PUshing ${TARGET_BRANCH}..."
            git push origin HEAD
        fi
    fi
}

gcpu() {
    # git commit and push
    if [[ ${1:-} == "help" || $1 == "--help" ]]; then
        echo "Optionally adds all unstaged changes, commits, and pushes to origin"
        echo "Usage: gacp [-a] [-m <message>]"
        return 1
    fi

    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    COMMAND=""

    if [[ ${1:-} == "-a" ]]; then
        COMMAND="git add --all && "
        shift
    fi

    if [[ ${1:-} == "-m" && $2 ]]; then
        COMMAND+="git commit -m '$2' && "
    else
        COMMAND+="git commit && "
    fi

    COMMAND+="git push origin $BRANCH"

    $COMMAND
}

gnuke() {
    # delete local and remote branch
    if [[ $# -eq 0 || ${1:-} == "help" || ${1:-} == "--help" ]]; then
        echo "Usage: gnuke <branch>"
        return 1
    fi

    git remote | xargs -L1 -I remote git push --delete remote "$@" 2>/dev/null
    git branch -D "$@" 2>/dev/null
}

gnukethis() {
    # delete current branch and it's remote
    BRANCH=$(git rev-parse --abbrev-ref HEAD)

    git remote | xargs -L1 -I remote git push --delete remote "${BRANCH}"
    git branch -D "${BRANCH}"
}

glc() {
    # git log copy - copy the git log for this branch to the clipboard
    # shellcheck disable=SC2046
    LOG="$(git log \"origin/$(__git_master_or_main)..HEAD\")"

  pbcopy <<EOF

\`\`\`
${LOG}
\`\`\`
EOF
}

opr() {
    # [o]pen [p]ull [r]equest - open a pull request for the current branch
    # Real URL example: https://gitlab.com/${ORG_NAME}/${PROJECT_NAME}/${REPO_NAME}/-/merge_requests/new?merge_request%5Bsource_branch%5D=feature%2Frf%2FEN-4597--docker-add-health-check

    REPO=$(basename "$(git rev-parse --show-toplevel)")
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    BRANCH_ENCODED=$(python3 -c "from urllib.parse import quote_plus; import json;s=quote_plus(json.dumps(\"${BRANCH}\"));print(s)")
    HOST="https://gitlab.com/${ORG_NAME}"
    ROUTE="${REPO}/-/merge_requests/new"
    QUERY="utf8=%E2%9C%93&merge_request%5Bsource_project_id%5D=21762811&merge_request%5Bsource_branch%5D=${BRANCH_ENCODED}&merge_request%5Btarget_project_id%5D=21762811&merge_request%5Btarget_branch%5D=$(__git_master_or_main)"

    glc
    open "${HOST}/${ROUTE}?${QUERY}"
}
