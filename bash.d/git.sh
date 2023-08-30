log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  Alises
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading aliases..."

# main
alias g="git"
alias gb="git_branch"
alias gba="git branch --all"
alias gbn="__git_get_cur_branch_name"
alias gco="__git_checkout"
alias gcod="git checkout develop"
alias gcom="git checkout \$(__git_master_or_main)"
alias gd="__git_diff_so_fancy_with_less"
alias gd1="__git_diff_so_fancy_with_less HEAD~"
alias gdd="__git_diff_so_fancy_with_less origin/develop..."
alias gdm="__git_diff_so_fancy_with_less origin/\$(__git_master_or_main)..."
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
alias ga.="__git_add --all"
alias ga="__git_add"
alias gab="git_absorb"
alias gac="pre-commit run --all-files && __git_add --update && git commit --no-verify --gpg-sign"
alias gc="git commit --gpg-sign"
alias gcp="git cherry-pick -x" # -x: add "cherry-picked from..." message
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
    if declare -f -F __git_complete >/dev/null; then
        # checkout
        __git_complete __git_checkout _git_checkout
        __git_complete gcod _git_checkout
        __git_complete gcom _git_checkout

        # add
        __git_complete ga _git_add

        # branch
        __git_complete gb _git_branch
        __git_complete git_branch _git_branch

        # stash
        __git_complete gst _git_stash

        #rebase
        __git_complete grb _git_rebase
    fi
}
__git_add_completion_to_aliases

function __git_wrap_gffm() {
    # add git merge completion
    declare -f -F __git_func_wrap >/dev/null
    if [[ -n $? ]]; then
        __git_func_wrap _git_merge
    fi
}
complete -o bashdefault -o default -o nospace -F __git_wrap_gffm gffm

function __git_wrap_gnuke() {
    # add git checkout completion
    declare -f -F __git_func_wrap >/dev/null
    if [[ -n $? ]]; then
        __git_func_wrap _git_checkout
    fi
}
complete -o bashdefault -o default -o nospace -F __git_wrap_gnuke gnuke

# ------------------------------------------------
#  Private
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading private functions..."

# Extend git cmds
function __git_add() {
    git_root="$(__git_project_root)"

    (
        cd "${git_root}" || exit 1
        git add "$@"

        local changed_files
        changed_files="$(git status --short --no-renames | cut -d ' ' -f 3-)"

        fix_missing_newline "${changed_files}"

        git add "$@"
    )
}

# Repository information
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

    printf "%s" "${main_branch}"
}

function __git_get_cur_branch_name() {
    git rev-parse --abbrev-ref HEAD
}

function __git_show_branch_state() {
    local branch
    local icon

    branch="$(git rev-parse --abbrev-ref HEAD)"
    icon="$(__git_parse_dirty)"

    printf "%s" "${branch}${icon}"
}

function __git_parse_dirty() {
    case $(git status 2>/dev/null) in
    *"Changes not staged for commit"*)
        printf "%s\n" " ${RED}✗"
        ;;
    *"Changes to be committed"*)
        printf "%s\n" " ${YELLOW}✗"
        ;;
    *"nothing to commit"*)
        printf "%s\n" " ${GREEN}✔︎"
        ;;
    esac
}

function __git_project_root() {
    printf "%s" "$(git rev-parse --show-toplevel 2>/dev/null)"
}

function __git_status_vs_master() {
    printf "%s\n" \
        "==> Log: " \
        "$(indent_output "$(git log "$(__git_master_or_main)..")")" \
        "" \
        "==> Diff:" \
        "$(indent_output "$(git diff --stat "$(__git_master_or_main)")")"
}

function __git_status_vs_develop() {
    if git show-ref --verify --quiet "refs/heads/$(__git_master_or_main)"; then
        printf "%s\n" \
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
        --format=format:'%x09%C(bold blue)%h%C(reset) -%C(auto)%d%C(reset) %C(yellow)%<(50,trunc)%s%C(reset) %C(normal)[%cn]%C(reset) %C(bold green)(%ar)%C(reset)' \
        "$@" |
        LESS -SFX -R
}

function __git_log_branch_no_trunc_msg() {
    git log \
        --graph \
        --color \
        --decorate=short \
        --format=format:'%x09%C(bold blue)%h%C(reset) -%C(auto)%d%C(reset) %C(yellow)%s%C(reset) %C(normal)[%cn]%C(reset) %C(bold green)(%ar)%C(reset)' \
        "$@" |
        LESS -SFX -R
}

function __git_log_branch_only_msg() {
    git log --color --format=format:'• %C(yellow)%s%C(reset)' "$@" | LESS -SFX -R
}

function __git_log_all_branches() {
    git log \
        --branches \
        --remotes \
        --graph \
        --color \
        --decorate=short \
        --format=format:'%x09%C(bold blue)%h%C(reset)%C(auto)%d%C(reset) %C(yellow)%<(60,trunc)%s%C(reset) %C(normal)[%cn]%C(reset) %C(bold green)(%ar)%C(reset)' \
        "$@" |
        LESS -SFX -R
}

function __git_log_all_branches_no_trunc_msg() {
    git log \
        --branches \
        --remotes \
        --graph \
        --color \
        --decorate=short \
        --format=format:'%x09%C(bold blue)%h%C(reset) -%C(auto)%d%C(reset) %C(yellow)%s%C(reset) %C(normal)[%cn]%C(reset) %C(bold green)(%ar)%C(reset)' |
        LESS -SFX -R
}

function __git_get_merged_branches() {
    git branch --all --merged "origin/$(__git_master_or_main)" |
        "${BREW_PREFIX}/bin/rg" --invert-match '>|master|main|develop|release' |
        tr -d ' '
}

# ------------------------------------------------
#  Public
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading public functions..."

# Committing
function git_absorb() {
    __git_add -u
    git absorb --and-rebase "$@"
}

function git_fixup() {
    local merge_base
    merge_base="$(git merge-base "$(__git_master_or_main)" HEAD)"

    __git_add --update
    git log -n 50 --pretty=format:"%h %s" --no-merges |
        fzf |
        awk '{print $1}' |
        xargs -o hub commit --fixup
    git rebase --interactive "${merge_base}"
}

# Branching
function git_branch() {
    case ${1:-} in
    -D | -m)
        git branch "${@}"
        ;;
    *)
        git branch "${@}" | fzf
        ;;
    esac
}

function __git_checkout() {
    if [[ ${1:-} ]]; then
        git checkout "${@}"
    else
        git branch --all |
            tr -d " " |
            sed -e "s,^remotes/origin/,," |
            sed -e "s,^HEAD.*,," |
            sort -u |
            fzf |
            xargs git checkout
    fi
}

function git_delete_merged_branches() {
    REMOTES="${*:-origin}"
    printf_callout "Fetching updates..."
    git fetch --prune &>/dev/null
    git remote prune origin &>/dev/null

    CUR_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    LOCAL_BRANCHES=$(__git_get_merged_branches |
        /usr/local/opt/grep/libexec/gnubin/grep -Ev "^\s*remotes/origin/" |
        /usr/local/opt/grep/libexec/gnubin/grep -Ev "${CUR_BRANCH}" |
        awk '{print $1}')
    REMOTE_BRANCHES=$(__git_get_merged_branches |
        /usr/local/opt/grep/libexec/gnubin/grep -E "^\s*remotes/origin/" |
        sed -e "s/^\s*remotes\/origin\///g" |
        awk '{print $1}')

    if [[ -n ${LOCAL_BRANCHES} || -n ${REMOTE_BRANCHES} ]]; then
        printf_callout "Branches that have been merged to $(__git_master_or_main):"
        __git_get_merged_branches

        prompt_to_continue "Delete branches?" || return 6
        echo

        if [[ -n ${LOCAL_BRANCHES} ]]; then
            printf_callout "Deleting merged local branches..."
            git branch --delete --force "${LOCAL_BRANCHES}"
        fi

        if [[ -n ${REMOTE_BRANCHES} ]]; then
            for REMOTE in ${REMOTES}; do
                printf_callout "Deleting merged remote branches from ${REMOTE}..."
                git push --delete "${REMOTE}" "${REMOTE_BRANCHES}"
            done
        fi

        git fetch --prune &>/dev/null
        git remote prune origin &>/dev/null
        printf_callout "Merged branches have been deleted..."
        printf_callout 'Everyone should run `git fetch --prune` to sync with this remote.'
    else
        printf_callout "No merged branches to delete."
    fi
}

git_rebase_merge_and_push() {
    local main_branch
    local source_branch
    local target_branch
    local merge_commit_option

    source_branch="$(__git_get_cur_branch_name)"
    main_branch="$(__git_master_or_main)"
    merge_commit_option="--no-ff"

    if [[ ${1:-} == "--ff-only" ]]; then
        merge_commit_option="--ff-only"
        shift
    fi

    if [[ -z ${1:-} ]]; then
        target_branch="${main_branch}"
    fi

    if [[ ${1:-} == "help" || ${1:-} == "--help" ]]; then
        print "%s\n" \
            "Usage: gm [--ff-only] [<TARGET_BRANCH>]" \
            "" \
            "DESCRIPTION" \
            "    Rebase current branch on to TARGET_BRANCH then merge and push. Prints the" \
            "    log and stat of the current branch vs TARGET_BRANCH. Prompts for" \
            "    confirmation before merging or pushing." \
            "" \
            "    If no TARGET_BRANCH, the current branch will be merged to ${main_branch}."
    else
        printf_callout "Updating ${target_branch}..."
        git checkout "${target_branch}" >/dev/null 2>&1
        git fetch --prune >/dev/null 2>&1
        git pull --rebase >/dev/null 2>&1
        git checkout "${source_branch}" >/dev/null 2>&1

        printf_callout "Changes to be merged into ${target_branch}:"
        git log --color --oneline "origin/${target_branch}..HEAD" | indent_output
        printf "\n"
        git diff --color --stat "origin/${target_branch}" | indent_output
        printf "\n"

        # prompt user
        if ! prompt_to_continue "Merge to ${target_branch} using ${merge_commit_option}?"; then
            git checkout "${source_branch}" >/dev/null 2>&1
            return 6
        fi

        printf_callout "Updating from origin..."
        git fetch -p >/dev/null 2>&1

        printf_callout "Rebasing onto ${target_branch}..."
        git checkout "${target_branch}" >/dev/null 2>&1
        git pull -r >/dev/null 2>&1
        git rebase "origin/${target_branch}" >/dev/null 2>&1

        printf_callout "Merging to ${target_branch} and deleting ${source_branch}..."
        printf "    "
        if git merge --no-stat "${merge_commit_option}" "${source_branch}" 2>&1 | indent_output; then
            git push origin --delete "${source_branch}" 2>/dev/null | indent_output
            git branch --delete "${source_branch}" 2>&1 | indent_output
        else
            printf_error "ERROR: merge failed, exiting."
            git checkout "${source_branch}" 2>&1 | indent_output
            return 6
        fi
        printf "\n"

        # prompt user
        if ! prompt_to_continue "Push to origin?"; then
            git checkout "${source_branch}" 2>&1 | indent_output
            return 6
        fi

        printf_callout "Pushing ${target_branch}..."
        git push --progress origin HEAD 2>&1 | indent_output
        printf "\n"
    fi
}

gcpu() {
    # git commit and push
    if [[ ${1:-} == "help" || ${1:-} == "--help" ]]; then
        echo "Optionally adds all unstaged changes, commits, and pushes to origin"
        echo "Usage: gacp [-a] [-m <message>]"
        return 1
    fi

    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    COMMAND=""

    if [[ ${1:-} == "-a" ]]; then
        COMMAND="__git_add --all && "
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

gcot() {
    TICKET=$(echo "${@}" |
        tr -t "${@}" 50 |
        sed "s/^[\.\/]//" |
        tr -s " " "-" |
        tr -cd "[:alnum:]._-/" |
        tr "[:upper:]" "[:lower:]")

    __git_checkout -b "${TICKET}"
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