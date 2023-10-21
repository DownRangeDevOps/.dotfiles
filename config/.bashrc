# .bashrc
if [[ -n ${DEBUG:-} ]]; then
    set +ua
    # shellcheck disable=SC1091
    source "${HOME}/.dotfiles/lib/log.sh"
    set -ua
    log debug ""
    log debug "==> [${BASH_SOURCE[0]}]"
fi

# ------------------------------------------------
#  bash
# ------------------------------------------------
if [[ -n ${DEBUG:-} ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating BASH aliases..."
fi

# auto on yubiswitch
alias ssh="osascript -e 'tell application \"yubiswitch\" to KeyOn' && ssh"
alias scp="osascript -e 'tell application \"yubiswitch\" to KeyOn' && scp"

alias c="clear"
alias genpasswd="openssl rand -base64 32"
alias myip="curl icanhazip.com"
alias sb='source ${HOME}/.bash_profile'

# safety
alias chown="chown --preserve-root"
alias chmod="chmod --preserve-root"
alias chgrp="chgrp --preserve-root"
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
set -o noclobber

# tmux & tmuxinator
alias tmux='tmux -2'              # force 256 colors in tmux
alias tks='tmux kill-session -t ' # easy kill tmux session
alias rc='reattach-to-user-namespace pbcopy'

# info
alias ls="list_dir"
alias ll="list_dir --long"

# navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ..r="cd \$(git_project_path --absolute)"
alias ..~="cd \${HOME}"

# squeltch egrep warnings
alias egrep="grep -E"

# helpers
alias mkdir="mkdir -pv"
alias j="jobs -l"
alias now="date +'%T'"
alias today="date +'%d-%m-%Y'"
alias ping="ping -c 5"
alias fping="ping -c 100 -s.2"
alias header="curl -I"             # get server headers
alias headerc="curl -I --compress" # does server support gzip / mod_deflate?
alias wget="wget -c"               # resume downloads

# ------------------------------------------------
#  ansible
# ------------------------------------------------
if [[ -n ${DEBUG:-} ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating Ansible aliases..."
fi

# ansible vault shortcuts
alias avv='ansible-vault view'

# ------------------------------------------------
#  aws vault
# ------------------------------------------------
if [[ -n ${DEBUG:-} ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating aws-vault aliases..."
fi

alias av="aws-vault"
alias ave="aws-vault exec"

# ------------------------------------------------
#  docker
# ------------------------------------------------
if [[ -n ${DEBUG:-} ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating Docker aliases..."
fi

alias d="docker"
alias dV="docker version"
alias da="docker attach"
alias db="docker build"
alias dcm="docker commit"
alias dcp="docker cp"
alias dcr="docker create"
alias dd="docker diff"
alias ddep="docker deploy"
alias de="docker_exec"
alias dev="docker events"
alias dex="docker export"
alias dh="docker history"
alias di="docker image"
alias dim="docker import"
alias din="docker info"
alias dins="docker inspect"
alias dk="docker kill"
alias dl="docker logs"
alias dld="docker load"
alias dlin="docker login"
alias dlout="docker logout"
alias dn="docker network"
alias dp="docker pause"
alias dpl="docker pull"
alias dps="docker_ps"
alias dpt="docker port"
alias dpu="docker push"
alias dr="docker run --rm"
alias drm="docker rm"
alias drmi="docker rmi"
alias drn="docker rename"
alias drst="docker restart"
alias ds="docker save"
alias dsr="docker search"
alias dst="docker start"
alias dstp="docker stop"
alias dsts="docker stats"
alias dt="docker top"
alias dtg="docker tag"
alias dunp="docker unpause"
alias dup="docker update"
alias dv="docker volume"
alias dw="docker wait"

# helpers
alias dka='docker kill $(docker ps -q)'

# volume sub-commands
alias dvls="docker volume ls"

# system sub-commands
alias dsdf="docker system df"
alias dse="docker system envents"
alias dsi="docker system info"
alias dsp="docker system prune"

# docker compose
alias dc="docker compose"

# ------------------------------------------------
#  git
# ------------------------------------------------
if [[ -n ${DEBUG:-} ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating git aliases..."
fi

# general
alias g="git"
alias gf="git fetch --prune"
alias gp="git fetch --prune && git pull --rebase"
alias gs="git status"

# worktree
alias gwt="git worktree"
alias gwta="git worktree add"
alias gwtl="git worktree list"
alias gwtm="git worktree move"

# branch
alias gb="git branch"
alias gba="git branch --all"
alias gbn="git_get_cur_branch_name"
alias gcb="git_get_cur_branch_name"
alias gco="git_fuzzy_checkout"
alias gcod="git checkout develop"
alias gcom="git checkout \$(__git_master_or_main) && git pull --prune"
alias gd1="git diff HEAD~"
alias gd="git diff"
alias gdd="git diff origin/develop..."
alias gdm="git diff origin/\$(__git_master_or_main)..."
alias gdmb="git_delete_merged_branches"

# logging
alias gL-="git_log_all_branches_no_trunc_msg"
alias gL="git_log_all_branches"
alias gl-="git_log_branch_no_trunc_msg"
alias gl="git_log_branch"
alias glm="git_log_branch_only_msg"
alias gstat="git_status_vs_master"
alias gstatd="git_status_vs_develop"

# committing
alias ga.="git_add --all"
alias ga="git_add"
alias gab="git_absorb"
alias gac="pre-commit run --all-files && __git_add --update && git commit --no-verify --gpg-sign"
alias gc="git commit --gpg-sign"
alias gcp="git cherry-pick -x" # -x: add "cherry-picked from..." message
alias gcpu="git_commit_and_push"
alias gfu="git_fixup"
alias gqf="ga --update && gc --amend --no-edit && gfpo"
alias gst="git stash"

# rebasing
alias grb="git rebase --interactive --autosquash"
alias grba="git rebase --abort"
alias grbc="git rebase --continue"
alias grbd="gf && git rebase --interactive --autosquash origin/develop"
alias grbm="gf && git rebase --interactive --autosquash origin/\$(__git_master_or_main)"
alias grbs="gf && git rebase --interactive --autosquash \$(git merge-base HEAD origin/\$(__git_master_or_main))"

# merging
alias gm="git_rebase_merge_and_push"
alias gmerged="git_get_merged_branches"

# pushing
alias gpu="git push --set-upstream \$(git remote) HEAD"
alias gfpo="git push --force-with-lease origin HEAD"

# repository info
alias git-contributors="git shortlog --summary --email --numbered"

# helpers
alias gcot="git_checkout_ticket"
alias gcpu="git_commit_push"
alias ginit="git_init"
alias glc="git_log_copy"
alias gnuke="git_nuke_branch"
alias gnukethis="git_nuke_cur_branch"
alias opr="git_open_pull_request"

# ------------------------------------------------
#  homebrew
# ------------------------------------------------
if [[ -n ${DEBUG:-} ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating Homebrew alises..."
fi

# avoid linking against any shims
NO_SHIMS_PATH=$(printf "%s" "${PATH}" | sed -E 's,.*shims[^:]*:,,g')
alias brew='env PATH=${NO_SHIMS_PATH} brew'

# ------------------------------------------------
#  kubernetes
# ------------------------------------------------
if [[ -n ${DEBUG:-} ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating Kubernetes aliases..."
fi

alias k="kubectl"

# ------------------------------------------------
#  macos
# ------------------------------------------------
if [[ -n ${DEBUG:-} ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating MacOS aliases..."
fi

alias flushdns='sudo killall -HUP mDNSResponder'
alias showfiles='defaults write com.apple.finder AppleShowAllFiles true; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles false; killall Finder'

# fix screen flash when audio process dies
alias fixflash='sudo killall coreaudiod'

# ------------------------------------------------
#  terraform
# ------------------------------------------------
if [[ -n ${DEBUG:-} ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating Terraform aliases..."
fi

alias tf="terraform"
alias tfV="terraform version"
alias tfa="terraform apply"
alias tfc="terraform console"
alias tfd="terraform destroy"
alias tfdb="terraform debug"
alias tfe="terraform env"
alias tff="terraform fmt"
alias tffr="..r && terraform fmt -recursive && cd -"
alias tfg="terraform get"
alias tfgr="terraform graph"
alias tfi="terraform init"
alias tfim="terraform import"
alias tfo="terraform output"
alias tfp="terraform plan"
alias tfpu="terraform push"
alias tfpv="terraform providers"
alias tfr="terraform refresh"
alias tfs="terraform show"
alias tft="terraform taint"
alias tfu="terraform untaint"
alias tfug="terraform 0.12upgrade"
alias tful="terraform force-unlock"
alias tfv="terraform validate"
alias tfw="terraform workspace"

# project naviation
# alias cdp="cd \$(pwd | sed -e \"s|\(.*/projects\)/[^/]*/\(.*\)$|\1/production/\2/|\")"
# alias cds="cd \$(pwd | sed -e \"s|\(.*/projects\)/[^/]*/\(.*\)$|\1/staging/\2/|\")"
# alias cdd="cd \$(pwd | sed -e \"s|\(.*/projects\)/[^/]*/\(.*\)$|\1/demo/\2/|\")"
# alias cdt="cd \"${HOME}/dev/${ORG_ROOT)/src/ops/packages/terraform/projects/"
# alias cdv="cd \"${HOME}/dev/${ORG_ROOT)/src/ops/vendors/"

alias tfia=init_all_modules
alias tfva=validate_all_modules

# ------------------------------------------------
#  direnv
# ------------------------------------------------
if [[ -n ${DEBUG:-} ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Initalizing direnv..."
fi

set +ua
eval "$(direnv hook bash)"
set -ua

if [[ -n ${DEBUG:-} ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: .bashrc done..."
fi
# vi: ft=sh
