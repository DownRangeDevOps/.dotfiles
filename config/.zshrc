# shellcheck shell=bash
BASHRC_SOURCED="${BASHRC_SOURCED:-0}"
export BASHRC_SOURCED=$((BASHRC_SOURCED + 1))

# Globals
export PERSONAL_LAPTOP_USER="ryanfisher"

# Set base Homebrew paths
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# ------------------------------------------------
#  bash
# ------------------------------------------------
# auto on yubiswitch
# alias ssh="osascript -e 'tell application \"yubiswitch\" to KeyOn' && ssh"
# alias scp="osascript -e 'tell application \"yubiswitch\" to KeyOn' && scp"

alias c="clear"
alias genpasswd="openssl rand -base64 32"
alias myip="curl icanhazip.com"
alias sb="source \${HOME}/.zprofile && source \${HOME}/.zshrc"

# safety
alias chown="chown --preserve-root"
alias chmod="chmod --preserve-root"
alias chgrp="chgrp --preserve-root"
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
set -o noclobber

# tmux & tmuxinator
alias tmux="tmux -2"             # force 256 colors in tmux
alias tks="tmux kill-session -t" # easy kill tmux session
alias rc="reattach-to-user-namespace pbcopy"

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
alias ..r="cd \$(git_project_root)"
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
alias fr="find_replace"

# ------------------------------------------------
#  ansible
# ------------------------------------------------
# ansible vault shortcuts
alias avv='ansible-vault view'

# ------------------------------------------------
#  Granted
# ------------------------------------------------
alias assume='source $(asdf which assume)'

# ------------------------------------------------
#  Granted
# ------------------------------------------------

# ------------------------------------------------
#  aws vault
# ------------------------------------------------
alias av="aws-vault"
alias ave="aws-vault exec"
alias avl="aws-vault list"

# ------------------------------------------------
#  docker
# ------------------------------------------------
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
# general
alias g="git"
alias gf="git fetch --prune"
alias gp="git fetch --prune && git pull --rebase"
alias gs="git status --branch"

# repo/worktree
alias gr="git remote"
alias gwt="git worktree"
alias gwta="git worktree add"
alias gwtl="git worktree list"
alias gwtm="git worktree move"
alias gwtp="git worktree prune"
alias gwtr="git worktree remove"

# branch
alias gb="git branch"
alias gba="git branch --all"
alias gbn="git_get_cur_branch_name"
alias gcb="git_get_cur_branch_name"
alias gco="git_fuzzy_checkout"
alias gcod="git_checkout_and_update develop"
alias gcom="git_checkout_and_update \$(__git_master_or_main)"
alias gdmb="git_delete_merged_branches"

# diff
alias gd1="git diff HEAD~"
alias gd="git diff"
alias gdd="__git_diff_develop"
alias gdm="__git_diff_master"

# logging
alias gll="git log --oneline"
alias gl-="git_log"
alias gL-="git_log --all"
alias gl="git_log --truncate-subject"
alias gL="git_log --all --truncate-subject"
alias glm="git_log --subject-only"
alias gstat="git_status_vs_master"
alias glast="git log -1 HEAD --stat"
alias gstatd="git_status_vs_develop"

# committing
alias ga.="git_add --all"
alias ga="git_add"
alias gab="git_absorb"
alias gac="pre-commit run --all-files && __git_add --update && git commit --no-verify --gpg-sign"
alias gc="git commit --gpg-sign"
alias gcnv="git commit --gpg-sign --no-verify"
alias gcp="git cherry-pick -x" # -x: add "cherry-picked from..." message
alias gcpu="git_commit_and_push"
alias gfu="git_fixup"
alias gqf="git add --update && git commit --amend --no-edit && gfpo"
alias gst="git stash --all"

# rebasing
alias grb="git rebase --interactive --autosquash"
alias grba="git rebase --abort"
alias grbc="git rebase --continue"
alias grbd="git fetch --prune && git rebase --interactive --autosquash origin/develop"
alias grbm="git fetch --prune && git rebase --interactive --autosquash origin/\$(__git_master_or_main)"
alias grbs="git fetch --prune && git rebase --interactive --autosquash \$(git merge-base HEAD origin/\$(__git_master_or_main))"

# merging
alias gm="git_rebase_merge_and_push"
alias gmerged="git_get_merged_branches"

# pushing
alias gpu="git_push"
alias gfpo="git fetch --prune && git push --force-with-lease --set-upstream \$(git config --default origin --get clone.defaultRemoteName) HEAD"
alias gfpa="git_push --force-update-refs"

# repository info
alias git-contributors="git shortlog --summary --email --numbered"

# helpers
alias gcfr="git_configure_fetch_rules"
alias gwtpath="git rev-parse --path-format=absolute --git-common-dir"
alias gcot="git_checkout_ticket"
alias gcpu="git_commit_push"
alias ginit="git_init"
alias glc="git_log_copy"
alias gnuke="git_nuke_branch"
alias gnukethis="git_nuke_cur_branch"
alias opr="git_open_pull_request"

# gh
alias pr="gh_pr"
alias cpr="pr"
alias upr="pr"

# ------------------------------------------------
#  homebrew
# ------------------------------------------------
# avoid linking against any shims
# alias brew='env PATH=$(printf "%s" "${PATH}" | sed -E 's,.*shims[^:]*:,,g') brew'

# ------------------------------------------------
#  kubernetes
# ------------------------------------------------
alias k="kubectl"

# ------------------------------------------------
#  macos
# ------------------------------------------------
alias flushdns='sudo killall -HUP mDNSResponder'
alias showfiles='defaults write com.apple.finder AppleShowAllFiles true; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles false; killall Finder'

# fix screen flash when audio process dies
alias fixflash='sudo killall coreaudiod'

# ------------------------------------------------
#  terraform
# ------------------------------------------------
alias tf="terraform_wrapper"
alias tfV="terraform_wrapper version"
alias tfa="terraform_wrapper apply"
alias tfc="terraform_wrapper console"
alias tfd="terraform_wrapper destroy"
alias tfdb="terraform_wrapper debug"
alias tfe="terraform_wrapper env"
alias tff="terraform_wrapper fmt"
alias tffr="terraform_fmt_project"
alias tfg="terraform_wrapper get"
alias tfgr="terraform_wrapper graph"
alias tfi="terraform_wrapper init"
alias tfim="terraform_wrapper import"
alias tfo="terraform_wrapper output"
alias tfp="terraform_wrapper plan"
alias tfpu="terraform_wrapper push"
alias tfpv="terraform_wrapper providers"
alias tfr="terraform_wrapper refresh"
alias tfs="terraform_wrapper show"
alias tft="terraform_wrapper taint"
alias tfu="terraform_wrapper untaint"
alias tfug="terraform_wrapper 0.12upgrade"
alias tful="terraform_wrapper force-unlock"
alias tfv="terraform_wrapper validate"
alias tfw="terraform_wrapper workspace"

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
set +ua
direnv_path="$(command -v direnv)"
asdf_direnv_path="${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"

if [[ -n "${direnv_path}" ]]; then
    if [[ -f "${asdf_direnv_path}" ]]; then
        source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"
    else
        printf_warning "WARNING: direnv is setup, run \`asdf direnv setup --shell <shell> --version latest\`."
    fi
else
    printf_warning "WARNING: direnv is not installed, run \`asdf install direnv latest\` to install."
fi
set -ua

# ------------------------------------------------
# Non-login shells
# ------------------------------------------------
# Source profile when aws-vault runs interactive shell
if [[ -n "${AWS_VAULT:-}" && -z "${AWS_VAULT_LOGIN_SHELL_INITALIZED:-}" ]]; then
    export AWS_VAULT_LOGIN_SHELL_INITALIZED=1

    if [[ -n "${ZSH_VERSION}" ]]; then
        # shellcheck disable=SC1090
        [[ -f "${HOME}/.zprofile" ]] && source ~/.zprofile
    else
        # shellcheck disable=SC1090
        [[ -f "${HOME}/.bash_profile" ]] && source ~/.bash_profile
    fi
fi

# ------------------------------------------------
# fzf Catppuccin theme
# ------------------------------------------------
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--color=border:#313244,label:#cdd6f4"

# ------------------------------------------------
# Externally managed
# ------------------------------------------------
set +ua

# shellcheck disable=SC1090
source ~/.dotfiles/config/.termrc

# Enable ASDF
"${HOMEBREW_PREFIX}/opt/asdf/libexec/asdf.sh"
ASDF_PYAPP_DEFAULT_PYTHON_PATH="${HOME}/.asdf/shims/python"

# Use Starship for my shell prompt
if [[ -n "${ZSH_VERSION:-}" ]]; then
    eval "$(starship init zsh)"
else
    eval "$(starship init bash)"
fi
