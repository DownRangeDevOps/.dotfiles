# shellcheck shell=bash disable=SC2296

if [[ -n ${DEBUG:-} ]]; then
    log debug ""
    log debug "==> [$0]"
fi

# ------------------------------------------------
#  Completion
# ------------------------------------------------
function __git_add_completion_to_aliases() {
    if declare -f -F __git_complete >/dev/null; then
        # git (main command)
        __git_complete g __git_main

        # add
        __git_complete ga _git_add
        __git_complete git_add _git_add

        # branch
        __git_complete gb _git_branch
        __git_complete git_branch _git_branch
        __git_complete gnuke _git_branch
        __git_complete git_nuke_branch _git_branch

        # diff
        __git_complete  gd _git_diff
        __git_complete  gdd _git_diff
        __git_complete  gdm _git_diff

        # checkout
        __git_complete gco _git_branch
        __git_complete git_fuzzy_checkout _git_checkout
        __git_complete grb _git_checkout

        # merge
        __git_complete gm _git_merge
        __git_complete git_rebase_merge_and_push _git_merge

        # rebase
        __git_complete grb _git_branch
    fi
}
__git_add_completion_to_aliases

# ------------------------------------------------
#  Private
# ------------------------------------------------
if [[ -n ${DEBUG:-} ]]; then
    log debug "[$(basename "$0")]: Loading private functions..."
fi

# Repository information
function __git_is_repo() {
    if [[ -n ${1:-} ]]; then
        git -C "$1" rev-parse --show-toplevel &>/dev/null
    else
        git rev-parse --show-toplevel &>/dev/null
    fi
}

function __git_is_worktree() {
    local git_dir
    local git_common_dir
    git_dir=$(realpath "$(git rev-parse --git-dir)")
    git_common_dir=$(realpath "$(git rev-parse --git-common-dir)")

    if [[ ${git_dir} != "${git_common_dir}" ]]; then
        return 0
    else
        return 1
    fi
}

function __git_master_or_main() {
    local master_exists
    local main_exists
    local main_branch

    if ! __git_is_repo "${PWD}"; then
        printf_error "${PWD} is not a git repository!" >&2
        return 6
    fi

    if git show-ref --verify --quiet refs/remotes/origin/master || git show-ref --verify --quiet refs/heads/master; then master_exists=true; fi
    if git show-ref --verify --quiet refs/remotes/origin/main || git show-ref --verify --quiet refs/heads/main; then main_exists=true; fi

    if [[ -n ${master_exists:-} && -n ${main_exists:-} ]]; then
        local longest_branch_len=0
        local main_branch="main"

        for ref in "origin/main" "origin/master" "main" "master"; do
            branch_len=$(git rev-list --count "${ref}" 2>/dev/null || printf "0")

            if [[ ${branch_len} -gt ${longest_branch_len} ]]; then
                main_branch="${ref##*"/"}"
                longest_branch_len="${branch_len}"
            fi
        done

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

function git_get_cur_branch_name() {
    git rev-parse --abbrev-ref HEAD | tee >(pbcopy)
}

function __git_show_branch_state() {
    local branch
    local icon

    branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    icon="$(__git_parse_dirty 2>/dev/null)"

    if [[ ${branch} == "HEAD" && $(git rev-parse --is-bare-repository) == "true" ]]; then
        branch="bare"
    fi

    printf "%s" "${branch}${icon}"
}

function __git_parse_dirty() {
    case $(git status 2>/dev/null) in
        *"Changes not staged for commit"*)
            printf "%b" "${RED}✗${RESET}"
            ;;
        *"Changes to be committed"*)
            printf "%b" "${YELLOW}✗${RESET}"
            ;;
        *"nothing to commit"*)
            printf "%b" " ${GREEN}✔︎${RESET}"
            ;;
    esac
}

function git_status_vs_master() {
    printf "%s\n" \
        "==> Log: " \
        "$(indent_output "$(git log "$(__git_master_or_main)..")")" \
        "" \
        "==> Diff:" \
        "$(indent_output "$(git diff --stat "$(__git_master_or_main)")")"
}

function git_status_vs_develop() {
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
function __git_diff_develop() {
    git diff "${@}" origin/develop...
}

function __git_diff_master() {
    local main_branch
    main_branch="$(__git_master_or_main)"

    git diff "${@}" "origin/${main_branch}..."
}

function __git_diff_so_fancy_with_less() {
    git diff --color "${1:-@}" | diff-so-fancy | less --tabs=4 -RFX
}

function __git_get_merged_branches() {
    local protected_branches

    # shellcheck disable=SC2206
    protected_branches="$(gh api repos/:owner/:repo/branches |
        jq -r '.[] |
        select(.protected == true) |
        .name' |
        paste -sd '|' -)"

    git branch --all --merged "origin/$(__git_master_or_main)" |
        "${HOMEBREW_PREFIX}/bin/rg" --invert-match "(\*|${protected_branches})" |
        tr -d " "
}

# ------------------------------------------------
#  Public
# ------------------------------------------------
if [[ -n ${DEBUG:-} ]]; then
    log debug "[$(basename "$0")]: Loading public functions..."
fi

# Info
function git_project_root() {
    printf "%s" "$(git rev-parse --show-toplevel 2>/dev/null)"
}

function git_project_path() { # TODO: do I need this? have git_project_root
    local git_toplevel
    local git_toplevel_basename
    local git_intra_repo_path

    if __git_is_worktree; then
        git_toplevel="$(dirname "$(git rev-parse --git-common-dir)")"
    else
        git_toplevel="$(git rev-parse --show-toplevel 2>/dev/null)"
    fi

    if [[ -z ${git_toplevel} ]]; then
        git_toplevel=${PWD}
    fi

    git_toplevel_basename="${git_toplevel##*/}"
    git_intra_repo_path=${PWD##*"${git_toplevel_basename}"}

    case ${1:-} in
    "--dirname")
        printf "%s" "${git_toplevel_basename}"
        ;;
    "--absolute")
        printf "%s" "${git_toplevel}"
        ;;
    *)
        printf "%s" "git@${git_toplevel_basename}${git_intra_repo_path}"
        ;;
    esac
}

# logging
function git_log() {
    local options="atsnid"
    local long_options="all,truncate-subject,subject-only,no-merges,include-upstream,date"
    local all=false
    local subject_only=false
    local colorize_signing_status=false
    local include_upstream=false
    local date_fmt="%cr"
    local git_args=(
        "--color"
        "--graph"
        "--decorate=short"
    )

    local signature_status
    local truncate_subject
    local parsed
    local format

    # Parse options
    parsed=$(parse_opts "${options}" "${long_options}" "$0" "$@")
    eval set -- "${parsed}"

    while true; do
        case "${1:-}" in
        -a | --all)
            all=true
            shift
            ;;
        -t | --truncate-subject)
            truncate_subject=",trunc"
            shift
            ;;
        -o | --subject-only)
            subject_only=true
            git_args=("--color")
            shift
            ;;
        -s | --show-signature)
            colorize_signing_status=true
            signature_status="(%G?) "
            shift
            ;;
        -n | --no-merges)
            git_args+=("--no-merges")
            shift
            ;;
        -i | --include-upstream)
            include_upstream=true
            shift
            ;;
        -d | --date)
            date_fmt="%cd"
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            git_args+=("${1}")
            shift || break
            ;;
        esac
    done

    # https://git-scm.com/docs/git-log#_pretty_formats
    # %C(...): color
    # %x09: tab
    # %h: short hash
    # %G?: signature status
    # %d: ref names
    # %s: subject
    # %cn: committer name
    # %cr: committer date, relative
    if ${subject_only}; then
        format="• %C(yellow)%s%C(reset)"
    else
        format="%x09%C(blue)%h ${signature_status}%C(reset)-%C(auto)%d %C(yellow)%<(72${truncate_subject})%s %C(blue)[%cn - ${date_fmt}]%C(reset)"
    fi

    # if ${all}; then git_args+=("--branches" "--remotes" "--tags"); fi
    if ${all}; then git_args+=("--all" "--exclude=refs/dangling/*"); fi

    git_args+=("--format=format:${format}")

    if ! ${include_upstream}; then git_args+=("--exclude=refs/remotes/upstream/*"); fi

    # debugging
    printf "%b " "${git_args[@]}" "\n"

    if ${colorize_signing_status}; then
        git log "${git_args[@]}" "$@" |
            sed -E \
                -e "s/\((G)\)/(${BOLD}${GREEN}\1${RESET}${BLUE})/g" \
                -e "s/\(([BR])\)/(${BOLD}${RED}\1${RESET}${BLUE})/g" \
                -e "s/\(([UE])\)/(${BOLD}${YELLOW}\1${RESET}${BLUE})/g" \
                -e "s/\(([XY])\)/(${BOLD}${WHITE}(\1${RESET}${BLUE})/g" |
            LESS -SFXR
    else
        git log "${git_args[@]}" "$@" | LESS -SFXR
    fi
}

# committing
function git_absorb() {
    git_add -u
    git absorb --and-rebase "$@"
}

function git_fixup() {
    local merge_base
    merge_base="$(git merge-base "origin/$(__git_master_or_main)" HEAD)"

    git_add --update
    git log -n 50 --pretty=format:"%h %s" --no-merges |
        fzf |
        awk '{print $1}' |
        xargs -o git commit --fixup
    git rebase --interactive "${merge_base}"
}

# merging
function git_rebase_merge_and_push() {
    local main_branch
    local source_branch
    local target_branch
    local merge_commit_option
    local skip_prompts=false

    source_branch="$(git_get_cur_branch_name)"
    main_branch="$(__git_master_or_main)"
    merge_commit_option="--no-ff"

    if [[ ${1:-} == "--ff-only" ]]; then
        merge_commit_option="--ff-only"
        shift
    fi

    if [[ ${1:-} == "-y" ]]; then
        skip_prompts=true
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

        if ! ${skip_prompts}; then
            if ! prompt_to_continue "Merge to ${target_branch} using ${merge_commit_option}?"; then
                git checkout "${source_branch}" >/dev/null 2>&1
                return 6
            fi
        else
            git checkout "${source_branch}" >/dev/null 2>&1
        fi

        printf_callout "Updating from origin..."
        git fetch -p >/dev/null 2>&1

        printf_callout "Rebasing onto ${target_branch}..."
        git checkout "${target_branch}" >/dev/null 2>&1
        git pull -r >/dev/null 2>&1
        git rebase "origin/${target_branch}" >/dev/null 2>&1

        printf_callout "Merging to ${target_branch} and deleting ${source_branch}..."
        if ! git merge --no-stat "${merge_commit_option}" "${source_branch}" 2>&1 | indent_output; then
            printf_error "ERROR: merge failed, exiting."
            git checkout "${source_branch}" 2>&1 | indent_output
            return 6
        fi
        printf "\n"

        if ! ${skip_prompts}; then
            if ! prompt_to_continue "Push to origin?"; then
                git checkout "${source_branch}" 2>&1 | indent_output
                return 6
            fi
        else
            git checkout "${source_branch}" >/dev/null 2>&1
        fi

        printf_callout "Pushing ${target_branch}..."
        git push --progress origin HEAD 2>&1 | indent_output
        printf "\n"

        if ! ${skip_prompts}; then
            if ! prompt_to_continue "Delete ${source_branch}?"; then
                git checkout "${source_branch}" 2>&1 | indent_output
                return 6
            fi
            git push origin --delete "${source_branch}" 2>/dev/null | indent_output
            git branch --delete "${source_branch}" 2>&1 | indent_output
        else
            git push origin --delete "${source_branch}" 2>/dev/null | indent_output
            git branch --delete "${source_branch}" 2>&1 | indent_output
        fi
        printf "\n"
    fi
}

function git_push() {
    local refs

    if [[ $# -eq 0 ]]; then
        git push --set-upstream "$(git config --default origin --get clone.defaultRemoteName)" HEAD
    else
        case $1 in
        "--force-update-refs")
            if [[ -n "${ZSH_VERSION}" ]]; then
                refs=(${(f)"$(get_branch_refs_between_head_and_main)"})
            else
                readarray -t refs < <(get_branch_refs_between_head_and_main)
            fi

            git push \
                --set-upstream "$(git config --default origin --get clone.defaultRemoteName)" \
                --force-with-lease \
                "${refs[@]}"
            ;;
        *)
            git push "$@"
            ;;
        esac
    fi
}

function git_commit_push() {
    if [[ ${1:-} == "help" || ${1:-} == "--help" ]]; then
        echo "Optionally adds all unstaged changes, commits, and pushes to origin"
        echo "Usage: gacp [-a] [-m <message>]"
        return 1
    fi

    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    COMMAND=""

    if [[ ${1:-} == "-a" ]]; then
        COMMAND="git_add --all && "
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
# -------------------------------
# Utils
# -------------------------------

# Gets the closest protected branch that is a direct parent of the current branch
# and returns its full remote ref (e.g., "origin/main")
function git_get_branch_base_ref() {
    local remote_name="${1:-origin}"
    local current_branch
    local protected_branches
    local branch_found=false

    # Get current branch name
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    # Ensure we have the latest from remote
    git fetch "$remote_name" &>/dev/null

    # Get list of protected branches
    protected_branches=$(gh api "repos/:owner/:repo/branches" |
                         jq -r '.[] | select(.protected == true) | .name')

    if [[ -z "$protected_branches" ]]; then
        # Fallback to main/master if no protected branches found
        protected_branches=$(__git_master_or_main)
    fi

    # Use git log to find the branch point
    # First, create a list of all remote branch tips
    local all_branch_tips
    all_branch_tips=$(git for-each-ref --format="%(objectname)" "refs/remotes/$remote_name/*")

    # Find the closest branch using git rev-list
    for branch in $protected_branches; do
        # Skip branches that don't exist on remote
        if ! git rev-parse --verify --quiet "$remote_name/$branch" &>/dev/null; then
            continue
        fi

        # Get the commit where the current branch diverged from this protected branch
        local fork_point
        fork_point=$(git rev-list -n1 "$(git rev-parse "$remote_name/$branch")" --boundary HEAD...^"$remote_name/$branch" |
                     grep "^-" | cut -c2-)

        if [[ -n "$fork_point" ]]; then
            # Check if this fork point is the tip of the remote branch
            local branch_tip
            branch_tip=$(git rev-parse "$remote_name/$branch")

            if echo "$fork_point" | grep -q "$branch_tip"; then
                # This is a direct parent branch!
                printf "%s\n" "$remote_name/$branch"
                branch_found=true
                break
            else
                # Check if any commit between the fork point and the branch tip is contained
                # in our current branch - this indicates this is a parent
                local contains_fork_point
                contains_fork_point=$(git branch -r --contains "$fork_point" | grep "^[[:space:]]*$remote_name/$branch\$")

                if [[ -n "$contains_fork_point" ]]; then
                    printf "%s\n" "$remote_name/$branch"
                    branch_found=true
                    break
                fi
            fi
        fi
    done

    # If no direct parent branch found, try a different approach - use branching history
    if [[ "$branch_found" == "false" ]]; then
        # Sort branches by commit time to find the most recent one that's an ancestor
        for branch in $(for b in $protected_branches; do
                           if git rev-parse --verify --quiet "$remote_name/$b" &>/dev/null; then
                               git show -s --format="%ct $b" "$remote_name/$b"
                           fi
                        done | sort -nr | cut -d' ' -f2-); do

            # Check if the branch is an ancestor of our current branch
            if git merge-base --is-ancestor "$remote_name/$branch" HEAD 2>/dev/null; then
                # This is the most recent ancestor branch
                printf "%s\n" "$remote_name/$branch"
                branch_found=true
                break
            fi
        done
    fi

    # If still no branch found, fall back to default branch
    if [[ "$branch_found" == "false" ]]; then
        printf "%s\n" "$remote_name/$(__git_master_or_main)"
    fi
}

# Get the SHA of the branch base reference
function git_get_branch_base_sha() {
    local base_ref
    base_ref=$(git_get_branch_base_ref)

    if [[ -n "$base_ref" ]]; then
        git rev-parse "$base_ref"
    fi
}

# Gets the SHA of the closest protected parent branch
function git_get_branch_base_sha() {
    local base_ref
    base_ref=$(git_get_branch_base_ref)

    if [[ -n "$base_ref" ]]; then
        git rev-parse "$base_ref"
    fi
}

function git_get_commits_by_this_branch() {
    local base
    base=$(git_get_branch_base_ref)

    printf "%s\n" "$(git rev-list --no-merges "${base}...HEAD")"
}

function get_branch_refs_between_head_and_main() {
    local main_ref
    local commit_shas
    local tmp
    local refs=()

    git fetch --prune

    main_ref=$(__git_master_or_main)
    if [[ -n "${ZSH_VERSION}" ]]; then
        commit_shas=(${(f)"$(git log --format="%H" --no-merges HEAD "^origin/${main_ref}")"})
    else
        readarray -t commit_shas < <(git log --format="%H" --no-merges HEAD "^origin/${main_ref}")
    fi

    for sha in "${commit_shas[@]}"; do
        if [[ -n "${ZSH_VERSION}" ]]; then
            tmp=(${(f)"$(git branch --contains "${sha}" | sed -E "s/^[\* ]+//")"})
        else
            readarray -t tmp < <(git branch --contains "${sha}" | sed -E "s/^[\* ]+//")
        fi

        refs+=("${tmp[@]}")
    done

    printf "%s\n" "${refs[@]}" | sort -u
}

function git_configure_fetch_rules() {
    if ! __git_is_repo; then
        printf_error "Current directory is not a repository"
        return 1
    fi

    if [[ ${1:-} == "--help" || ${1:-} == "-h" ]]; then
        printf "%s\n" "Usage: git_config_remote <path>"
        return 1
    fi

    printf_callout "Adding fetch refs for origin to git config..."
    git "${@}" config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

    printf_callout "Fetching updates..."
    git "${@}" fetch --prune

}

function git_init() {
    if [[ ${1:-} == "--help" || ${1:-} == "-h" ]]; then
        printf "%s\n" "Usage: git_init [<path>]"
        return 0
    fi

    local repo_root="${1:-./}"

    command mkdir -pv "$1"
    (
        cd "${repo_root}" || return 1
        git init --bare
    )

    # printf "%s\n" "gitdir: .bare" > .git
    #
    # git worktree add main
    #
    # (
    #     cd main || return 1
    #     cp --force --interactive "${HOME}"/.dotfiles/config/git/.git-template/{.gitignore,.mailmap,.pre-commit-config.yaml} .
    #     git add --all
    #     git commit --message "Init"
    #     gh repo create
    # )
    #
    # git_remote_name=$(git -C main remote show)
    # git config "remote.${git_remote_name}.fetch" "+refs/heads/*:refs/remotes/origin/*"
}

function git_add() {
    (
        local changed_files
        changed_files="$(git status --short --no-renames | cut -d ' ' -f 3-)"

        fix_missing_newline "${changed_files}"

        git add "$@"
    )
}

# # WIP
# function git_fuzzy_branch(){
#     local fuzzy_args=("-d" "--delete" "-D")
#
#     if [[ $# -eq 1 && " ${fuzzy_args[*]} " =~ ${1:-} ]]; then
#         git branch
#     else
#         git branch "$@"
#     fi
# }

# branching
function git_checkout_and_update() {
    local msg
    msg=$(git checkout "${1:--}")

    if [[ ${msg} =~ "behind" ]]; then
        printf_callout "Pulling changes from the remote..."
        git pull --prune
    fi
}

function git_fuzzy_checkout() {
    if [[ -n ${1:-} ]]; then
        git checkout "${@}"
    else
        git branch --all |
            tr -d " " |
            sed -E "s,^remotes/origin/,," |
            sed -E "s,^HEAD.*,," |
            sort -u |
            fzf |
            xargs git checkout
    fi
}

function git_delete_merged_branches() {
    local remotes="${*:-origin}"
    local cur_branch
    local local_branches
    local remote_branches
    local main_branch

    cur_branch=$(git rev-parse --abbrev-ref HEAD)
    main_branch="$(__git_master_or_main)"

    printf_callout "Switching to ${main_branch}..."
    git_checkout_and_update "${main_branch}"

    printf "\n"
    printf_callout "Fetching updates..."
    git fetch --prune &>/dev/null
    git remote prune origin &>/dev/null

    # shellcheck disable=SC2206
    local_branches=(${(f)"$(__git_get_merged_branches |
        grep --extended-regexp --invert-match "^\s*remotes/origin/" |
        grep --extended-regexp --invert-match "${cur_branch}")"})

    # shellcheck disable=SC2206
    remote_branches=(${(f)"$(__git_get_merged_branches |
        grep --extended-regexp "^\s*remotes/origin/" |
        sed --regexp-extended "s/^\s*remotes\/origin\///g")"})

    if [[ ${#local_branches[@]} -gt 0 || ${#remote_branches[@]} -gt 0 ]]; then
        printf_callout "Branches that have been merged to $(__git_master_or_main):"
        __git_get_merged_branches | indent_output

        prompt_to_continue "Delete branches?" || return 6

        if [[ ${#local_branches[@]} -gt 0 ]]; then
            printf_callout "Deleting merged local branches..."
            # shellcheck disable=SC2068  # word splitting is desired here
            git branch --delete --force ${local_branches[@]} | indent_output
        fi

        if [[ ${#remote_branches[@]} -gt 0 ]]; then
            for remote in ${remotes}; do
                printf_callout "Deleting merged remote branches from ${remote}..."
                # shellcheck disable=SC2068  # word splitting is desired here
                git push --delete "${remote}" ${remote_branches[@]} | indent_output
            done
        fi

        git fetch --prune &>/dev/null
        git remote prune origin &>/dev/null

        git checkout "${cur_branch}"

        printf_callout "Done."
        printf_warning "Everyone should run \`git fetch --prune\` to sync with this remote."
    else
        git checkout "${cur_branch}"
        printf_warning "No merged branches to delete."
    fi
}

function git_nuke_branch() {
    # delete local and remote branch
    if [[ $# -eq 0 || ${1:-} == "help" || ${1:-} == "--help" ]]; then
        echo "Usage: gnuke <branch>"
        return 1
    fi

    git remote | xargs -L1 -I {} git push --delete origin "$@" 2>/dev/null
    git branch -D "$@" 2>/dev/null
}

function git_nuke_cur_branch() {
    # delete current branch and it's remote
    BRANCH=$(git rev-parse --abbrev-ref HEAD)

    git remote | xargs -L1 -I remote git push --delete remote "${BRANCH}"
    git branch -D "${BRANCH}"
}

function gh_check_for_pr() {
    results="$(gh pr list --head "$(git_get_cur_branch_name)" --state open | tail -1)"

    if [[ "${results}" == "*no pull requests*" || -z "${results}" ]]; then
        printf "%s" "false"
    else
        printf "%s" "true"
    fi
}

function gh_pr() {
    local origin_base_branch
    local local_base_branch
    local first_commit_subject
    local pr_title
    local args

    git fetch --prune

    # if [[ ! "$(git status 2>/dev/null | tail -1)" == "*nothing to commit*" ]]; then
    #     git add --update
    #     git commit --amend --no-edit
    # fi

    git push "$(git config --default origin --get clone.defaultRemoteName)" \
        --set-upstream \
        --force-with-lease \
        HEAD

    local git_push_status=$?

    git fetch --prune

    origin_base_branch=$(git_get_branch_base_ref)
    local_base_branch=$(sed -E "s,^origin/,," <<< "${origin_base_branch}")

    first_commit_subject="$(git log --reverse --format='%s' "${origin_base_branch}..HEAD" | head -1)"
    pr_title=$(sed -E "s/\[\[/[/" <<<"${first_commit_subject}" | sed -E "s/\]\]/]/")
    pr_body_file="$(mktemp -p /tmp)"

    git_log_copy --print >| "${pr_body_file}"

    args=(
        "--title"
        "${pr_title}"
        "--body-file"
        "${pr_body_file}"
    )

    if [[ ${git_push_status} -eq 0 ]]; then
        if [[ "$(gh_check_for_pr)" == "true" ]]; then
            printf_callout "Updating pull request..."
            gh pr edit "${args[@]}"
        else
            printf_callout "Creating pull request..."

            args+=(
                "--base"
                "${local_base_branch}"
            )

            gh pr create "${args[@]}"
        fi
    fi

    rm -f "${pr_body_file}"
}

function git_log_copy() {
    local tmpfile
    tmpfile="$(mktemp)"

    for commit in $(git_get_commits_by_this_branch); do
        git log -1 --format="## %s (%h)%n%n%b" "${commit}" >>"${tmpfile}"
    done

    pbcopy <"${tmpfile}"

    if [[ ${1:-} == "--print" || ${1:-} == "-p" ]]; then
        printf "%s\n" "$(<"${tmpfile}")"
    fi

    rm -rf "${tmpfile}"
}

function git_checkout_ticket() {
    TICKET=$(echo "${@}" |
        tr -t "${@}" 50 |
        sed "s/^[\.\/]//" |
        tr -s " " "-" |
        tr -cd "[:alnum:]._-/" |
        tr "[:upper:]" "[:lower:]")

    __git_checkout -b "${TICKET}"
}

function gitlab_open_pull_request() {
    # open a pull request for the current branch
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

# vim: set ft=zsh
