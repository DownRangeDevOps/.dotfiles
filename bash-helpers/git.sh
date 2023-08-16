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
alias gcod="git checkout develop"
alias gcom="git checkout \$(git_master_or_main)"
alias gd1="gd HEAD~"
alias gdd="gd origin/develop..."
alias gdm="gd origin/master..."
alias gdmb="git_delete_merged_branches"
alias gf="git fetch --prune"
alias gfu="git_fixup"
alias gp="gf && git pull --rebase"
alias gs="git status"

# logging
alias gl="git log --graph --color --decorate=short --format=format:'%C(bold blue)%h%C(reset) -%C(auto)%d%C(reset) %C(white)%<(50,trunc)%s%C(reset) %C(black)[%an]%C(reset) %C(bold green)(%ar)%C(reset)' | LESS -SFX -R"
alias gl-="git log --graph --color --decorate=short --format=format:'%C(bold blue)%h%C(reset) -%C(auto)%d%C(reset) %C(white)%s%C(reset) %C(black)[%an]%C(reset) %C(bold green)(%ar)%C(reset)' | LESS -SFX -R"
alias gl--="git log --color --format=format:'• %C(white)%s%C(reset)' | LESS -SFX -R"
alias gL="git log --branches --remotes --graph --color --decorate=short --format=format:'%C(bold blue)%h%C(reset) -%C(auto)%d%C(reset) %C(white)%<(50,trunc)%s%C(reset) %C(black)[%an]%C(reset) %C(bold green)(%ar)%C(reset)' | LESS -SFX -R"
alias gL-="git log --branches --remotes --graph --color --decorate=short --format=format:'%C(bold blue)%h%C(reset) -%C(auto)%d%C(reset) %C(white)%s%C(reset) %C(black)[%an]%C(reset) %C(bold green)(%ar)%C(reset)' | LESS -SFX -R"
# alias lg2="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"
# alias lg3="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n''          %C(white)%s%C(reset)%n''          %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'"
alias gstat='printf  "%s\n" \
    "==> Log: " \
    "$(git log origin/master..)" \
    "" \
    "==> Diff:" \
    "$(git diff --stat origin/master)" \
'
alias gstatd='printf  "%s\n" \
    "==> Log: " \
    "$(git log origin/develop..)" \
    "" \
    "==> Diff:" \
    "$(git diff --stat origin/develop)" \
'

# committing
alias ga.="git add --all"
alias ga="git add"
alias gc="pre-commit run --all-files && git add --update && git commit --no-verify --gpg-sign"
alias gcp="git cherry-pick -x"
alias gqf="ga -u && gc --amend --no-edit && gfpo"
alias gst="git stash"

# rebasing
alias grb="git rebase --interactive"
alias grba="git rebase --abort"
alias grbc="git rebase --continue"
alias grbd="gf && git rebase --interactive origin/develop"
alias grbm="gf && git rebase --interactive origin/\$(git_master_or_main)"
alias grbs="gf && git rebase --interactive \$(git merge-base HEAD origin/\$(git_master_or_main))"

# Merging
alias gm=gmerge
alias gmerged="git branch --all --merged origin/\$(git_master_or_main) \
    | /usr/local/opt/grep/libexec/gnubin/grep -Ev '>|master|main|develop|release' \
    | tr -d ' '"

# Pushing
alias gpu="git push -u \$(git remote) HEAD"
alias gfpo="git push --force-with-lease origin HEAD"

# Misc aliases for git based but non-git actions
alias gac="git diff origin/\$(git_master_or_main) \
    --stat \
    --diff-filter=ACdMRTUxB \
    !(roles.galaxy)"

# ------------------------------------------------
#  Helpers
# ------------------------------------------------
logger "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

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
    if [[ $1 == "-D" ]]; then
        git branch "${@}"
    else
        git branch "${@}"| fzf
    fi
}

function gco() {
    if [[ ${1} ]]; then
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
    LOCAL_BRANCHES=$(gmerged \
        | /usr/local/opt/grep/libexec/gnubin/grep -Ev "^\s*remotes/origin/" \
        | /usr/local/opt/grep/libexec/gnubin/grep -Ev "${CUR_BRANCH}" \
        | awk '{print $1}')
    REMOTE_BRANCHES=$(gmerged \
        | /usr/local/opt/grep/libexec/gnubin/grep -E "^\s*remotes/origin/" \
        | sed -e "s/^\s*remotes\/origin\///g" \
        | awk '{print $1}')

    if [[ -n ${LOCAL_BRANCHES} || -n ${REMOTE_BRANCHES} ]]; then
        printf_callout "Branches that have been merged to $(git_master_or_main):"
        gmerged

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

function __git_is_repo() {
    if [[ -n $1 ]]; then
        git -C "$1" rev-parse 2>/dev/null
    else
        git rev-parse 2>/dev/null
    fi
}

function git_master_or_main() {
    if ! __git_is_repo "${PWD}"; then
        printf "%s\n" "${PWD} is not a git repository."
        return 1
    fi

    INITIAL_COMMIT="$(git rev-list --abbrev-commit HEAD | tail -n 1)"

    git show-ref --verify --quiet refs/heads/master
    MASTER_EXISTS="${?}"

    git show-ref --verify --quiet refs/heads/main
    MAIN_EXISTS="${?}"

    if [[ -z ${MASTER_EXISTS} && -z ${MAIN_EXISTS} ]]; then
        MASTER_LENGTH="$(git rev-list --count "${INITIAL_COMMIT}..master")"
        MAIN_LENGTH="$(git rev-list --count "${INITIAL_COMMIT}..main")"

        if [[ ${MASTER_LENGTH} -gt ${MAIN_LENGTH} ]]; then
            MAIN_BRANCH="main"
        else
            MAIN_BRANCH="master"
        fi
    elif [[ ${MAIN_EXISTS} ]]; then
        MAIN_BRANCH="main"
    elif [[ ${MASTER_EXISTS} ]]; then
        MAIN_BRANCH="master"
    else
        printf "%s\n" "This repository does not have a 'master' or 'main' branch!"
        exit 1
    fi

    printf  "%s" "${MAIN_BRANCH}"
}

function gd() {
    git diff --color "${1:-@}" | diff-so-fancy | less --tabs=4 -RFX
}

function parse_git_branch () {
    git_branch | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

function parse_git_dirty () {
    case $(git status 2>/dev/null) in
        *"Changes not staged for commit"*)
            printf "%s\n" " ${RED}✗";;
        *"Changes to be committed"*)
            printf "%s\n" " ${YELLOW}✗";;
        *"nothing to commit"*)
            printf "%s\n" "";;
    esac
}

function git_project_parent() {
    printf "%s" "$(git rev-parse --show-toplevel 2>/dev/null)/.."
}

function git_project_root () {
    if [[ -n $(git branch 2>/dev/null) ]]; then
        printf "%s\n" "git@$(realpath --relative-to="$(git_project_parent)" .)"
    else
        printf "%s\n" "${PWD/~/\~}"
    fi
}

function git_branch () {
    git branch --no-color 2>/dev/null
}

# Add git completion
add_git_completion_to_aliases() {
    if declare -f -F __git_complete > /dev/null; then
        __git_complete gco _git_checkout
        __git_complete ga _git_add
        __git_complete gb _git_branch
        __git_complete gst _git_stash
        __git_complete grb _git_rebase
    fi
}
add_git_completion_to_aliases

__git_wrap_gffm() {
    declare -f -F __git_func_wrap > /dev/null
    if [[ -n $? ]]; then
        __git_func_wrap _git_merge
    fi
}
complete -o bashdefault -o default -o nospace -F __git_wrap_gffm gffm

__git_wrap_gnuke() {
    declare -f -F __git_func_wrap > /dev/null
    if [[ -n $? ]]; then
        __git_func_wrap _git_checkout
    fi
}
complete -o bashdefault -o default -o nospace -F __git_wrap_gnuke gnuke

gcot() {
  TICKET=$(echo "${@}" \
    | tr -t "${@}" 50 \
    | sed "s/^[\.\/]//" \
    | tr -s " " "-" \
    | tr -cd "[:alnum:]._-/" \
    | tr "[:upper:]" "[:lower:]")

  gco -b "${TICKET}"
}

gmerge() {
    # git merge --ff-only
    MAIN_BRANCH=$(git_master_or_main)

    if [[ $1 == "--ff-only" ]]; then
        MERGE_COMMIT_OPTION="--ff-only"
        shift
    else
        MERGE_COMMIT_OPTION="--no-ff"
    fi

    if [[ $1 == "help" || $1 == "--help" ]]; then
        print  "%s\n" \
            "Usage: gffm [OPTION] [<BRANCH>]" \
            "Merge BRANCH to ${MAIN_BRANCH} printing the log and stat, and" \
            "prompting before merging or pushing." \
            "" \
            "If no BRANCH, or BRANCH is HEAD, the current branch will be merged to ${MAIN_BRANCH}."
    else
        if [[ $1 == "HEAD" || $1 == "" ]]; then
            git log "origin/${MAIN_BRANCH}.."
            git diff --stat "origin/${MAIN_BRANCH}"
            prompt_to_continue "Merge to ${MAIN_BRANCH}?"

            printf_callout "Updating from origin..."
            git fetch -p

            printf_callout "Rebasing on ${MAIN_BRANCH}..."
            git checkout "${MAIN_BRANCH}"
            git pull -r
            git rebase "origin/${MAIN_BRANCH}"

            printf_callout "Merging to ${MAIN_BRANCH}..."

            if [[ $(git merge "${MERGE_COMMIT_OPTION}" "@{-1}") ]]; then
                git branch --delete "@{-1}"
                git push origin --delete "@{-1}"
            fi

            prompt_to_continue "Push to origin?"

            printf_callout "Pushing ${MAIN_BRANCH}..."
            git push origin HEAD
        else
            BRANCH=$1
            git checkout "${BRANCH}"

            printf_callout "Updating ${BRANCH}..."
            git fetch -p
            git pull -r
            git checkout "@{-1}"
            git log "${BRANCH}..@"
            git diff --stat "${BRANCH}"
            prompt_to_continue "Merge to ${BRANCH}?"

            printf_callout "Merging to ${BRANCH}..."
            git rebase "${BRANCH}"
            git checkout "${BRANCH}"

            if [[ $(git merge "${MERGE_COMMIT_OPTION}" "@{-1}") ]]; then
                git branch --delete "@{-1}"
                git push origin --delete "@{-1}"
            fi

            prompt_to_continue "Push to origin?"

            printf_callout "PUshing ${BRANCH}..."
            git push origin HEAD
        fi
    fi
}

gcpu() {
    # git commit and push
    if [[ $1 == "help" || $1 == "--help" ]]; then
        echo "Optionally adds all unstaged changes, commits, and pushes to origin"
        echo "Usage: gacp [-a] [-m <message>]"
        return 1
    fi

    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    COMMAND=""

    if [[ $1 == "-a" ]]; then
        COMMAND="git add --all && "
        shift
    fi

    if [[ $1 == "-m" && $2 ]]; then
        COMMAND+="git commit -m '$2' && "
    else
        COMMAND+="git commit && "
    fi

    COMMAND+="git push origin $BRANCH"

    $COMMAND
}

gnuke() {
    # delete local and remote branch
    if [[ $# -eq 0 || $1 == "help" || $1 == "--help" ]]; then
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
    LOG="$(git log \"origin/$(git_master_or_main)..HEAD\")"

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
    QUERY="utf8=%E2%9C%93&merge_request%5Bsource_project_id%5D=21762811&merge_request%5Bsource_branch%5D=${BRANCH_ENCODED}&merge_request%5Btarget_project_id%5D=21762811&merge_request%5Btarget_branch%5D=$(git_master_or_main)"

    glc
    open "${HOST}/${ROUTE}?${QUERY}"
}
