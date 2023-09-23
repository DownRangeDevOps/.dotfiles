# vim: set ft=sh:
# .bashrc

log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  BASH
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating BASH aliases..."

# auto on yubiswitch
alias ssh="osascript -e 'tell application \"yubiswitch\" to KeyOn' && ssh"
alias scp="osascript -e 'tell application \"yubiswitch\" to KeyOn' && scp"

alias c="clear"
alias ebash='nvim ${HOME}/.bash_profile'
alias ec=ebash
alias genpasswd="openssl rand -base64 32"
alias myip="curl icanhazip.com"
alias sb='source ${HOME}/.bash_profile'
alias vim="nvim"

# safety
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
set -o noclobber

# tmux & tmuxinator
alias tmux='tmux -2'              # Force 256 colors in tmux
alias tks='tmux kill-session -t ' # easy kill tmux session
alias rc='reattach-to-user-namespace pbcopy'

# Info
alias ls="list_dir"
alias ll="list_dir --long"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ..r="cd \$()"
alias ..~="cd \${HOME}"
alias ctags="\${BREW_PREFIX}/bin/ctags"

# Squeltch egrep warnings
alias egrep="grep -E"

# ------------------------------------------------
#  Ansible
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating Ansible aliases..."

# Ansible vault shortcuts
alias aav='ansible-vault view'

# ------------------------------------------------
#  AWS
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating AWS aliases..."

alias av="aws-vault"
alias ave="aws-vault exec"
alias avr="aws-vault exec msr-root --"
alias ava="aws-vault exec msr-amzn --"
alias avs="aws-vault exec msr-staging --"
alias avo="aws-vault exec msr-ops-sbx --"
alias avsci="aws-vault exec msr-sci-sbx --"

# ------------------------------------------------
#  Docker
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating Docker aliases..."

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

# docker kill
alias dka='docker kill $(docker ps -q)'

# docker volume
alias dvls="docker volume ls"

# docker system
alias dsdf="docker system df"
alias dse="docker system envents"
alias dsi="docker system info"
alias dsp="docker system prune"

# compose
alias dc="docker compose"

# ------------------------------------------------
#  Git
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating git aliases..."

# general
alias g="git"
alias gf="git fetch --prune"
alias gp="gf && git pull --rebase"
alias gs="git status"

# branch actions
alias gb="git_branch"
alias gba="git branch --all"
alias gbn="git_get_cur_branch_name"
alias gco="git_fuzzy_checkout"
alias gcod="git checkout develop"
alias gcom="git checkout \$(__git_master_or_main)"
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

# Merging
alias gm="git_rebase_merge_and_push"
alias gmerged="git_get_merged_branches"

# Pushing
alias gpu="git push --set-upstream \$(git remote) HEAD"
alias gfpo="git push --force-with-lease origin HEAD"

# Repository info
alias git-contributors="git shortlog --summary --email --numbered"

# Helpers
alias gcot="git_checkout_ticket"
alias gcpu="git_commit_push"
alias ginit="git_init"
alias glc="git_log_copy"
alias gnuke="git_nuke_branch"
alias gnukethis="git_nuke_cur_branch"
alias opr="git_open_pull_request"

# ------------------------------------------------
#  Homebrew
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating Homebrew alises..."

# Avoid linking against any shims
NO_SHIMS_PATH=$(printf "%s" "${PATH}" | sed -E 's,.*shims[^:]*:,,g')
alias brew='env PATH=${NO_SHIMS_PATH} brew'

# ------------------------------------------------
#  Kubernetes
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating Kubernetes aliases..."

alias k="kubectl"

# ------------------------------------------------
#  MacOS
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating MacOS aliases..."

alias flushdns='sudo killall -HUP mDNSResponder'
alias showfiles='defaults write com.apple.finder AppleShowAllFiles true; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles false; killall Finder'

# Fix screen flash when audio process dies
alias fixflash='sudo killall coreaudiod'

# ------------------------------------------------
#  Python
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating Python aliases..."

alias rmlp=run_mega_linter_python

# ------------------------------------------------
#  Terraform
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating Terraform aliases..."

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

# Project naviation
# alias cdp="cd \$(pwd | sed -e \"s|\(.*/projects\)/[^/]*/\(.*\)$|\1/production/\2/|\")"
# alias cds="cd \$(pwd | sed -e \"s|\(.*/projects\)/[^/]*/\(.*\)$|\1/staging/\2/|\")"
# alias cdd="cd \$(pwd | sed -e \"s|\(.*/projects\)/[^/]*/\(.*\)$|\1/demo/\2/|\")"
# alias cdt="cd \"${HOME}/dev/${ORG_ROOT)/src/ops/packages/terraform/projects/"
# alias cdv="cd \"${HOME}/dev/${ORG_ROOT)/src/ops/vendors/"

alias tfia=init_all_modules
alias tfva=validate_all_modules
