# shellcheck shell=bash
# .zshrc

# Globals
export PERSONAL_LAPTOP_USER="ryanfisher"
export DOTFILES_PREFIX="${HOME}/.dotfiles"
export BASH_D_PATH="${DOTFILES_PREFIX}/bash.d"
export PATH="${DOTFILES_PREFIX}/bin:${PATH}" # my bins

# Vale global config
export VALE_CONFIG_PATH="${HOME}/.dotfiles/config/vale/.vale.ini"
export VALE_STYLES_PATH="${HOME}/.dotfiles/config/vale/styles"

# ------------------------------------------------
# Set up terminal
# ------------------------------------------------

# shellcheck disable=SC1090
source ~/.dotfiles/config/.termrc

# History
export HISTSIZE=500000
export HISTFILESIZE=500000

if [[ -n "${ZSH_VERSION:-}" ]]; then
    setopt SHARE_HISTORY            # import old commands, append new, so all sessions have the same hist
    setopt HIST_IGNORE_ALL_DUPS     # do not put duplicated command into history list
    setopt HIST_SAVE_NO_DUPS        # omit older duplicates
    setopt HIST_REDUCE_BLANKS       # remove unnecessary blanks
else
    export HISTCONTROL=ignoreboth:erasedups # don't put duplicate lines in the history
    shopt -s histappend   # append
    shopt -s checkwinsize # check the win size after each command and update if necessary
    history -a            # append
    history -n            # read new lines and append
fi

if [[ -z "${ZSH_VERSION:-}" ]]; then
    # Search history with arrows, up: \e[A, down: \e[B
    # bind '"\e[A": history-search-backward'
    # bind '"\e[B": history-search-forward'
    for direction (up down) {
        autoload "${direction}-line-or-beginning-search"
        zle -N "${direction}-line-or-beginning-search"
        key="${terminfo}[kcu${direction}[1]1]"

        for key ("${key}" "${key/O/[}")
            bindkey "${key}" "${direction}-line-or-beginning-search"
    }

    if ((original_buffer_length == 0)); then
        CURSOR=$#BUFFER
    fi
fi

# ------------------------------------------------
# Set base Homebrew paths
# ------------------------------------------------
if [[ -n "$(command -v brew)" ]]; then
    if [[ $(uname -m) == "arm64" ]]; then
        # Source brew shellenv but with safer FPATH handling
        BREW_OUTPUT=$(/opt/homebrew/bin/brew shellenv | grep -v "fpath")
        eval "$BREW_OUTPUT"

        # Add Homebrew completions to FPATH manually
        FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
    else
        # Source brew shellenv but with safer FPATH handling
        BREW_OUTPUT=$(/usr/local/bin/brew shellenv | grep -v "fpath")
        eval "$BREW_OUTPUT"

        # Add Homebrew completions to FPATH manually
        FPATH="/usr/local/share/zsh/site-functions:$FPATH"
    fi
fi

# ------------------------------------------------
# Load ZSH completion system after setting up FPATH
# ------------------------------------------------
autoload -Uz compinit
compinit

# Make compdef available
autoload -Uz compdef

# ------------------------------------------------
# Source dependencies in case this is a non-login shell
# ------------------------------------------------
[[ -f "${BASH_D_PATH}/lib.sh" ]] && source "${BASH_D_PATH}/lib.sh"

# ------------------------------------------------
#  general
# ------------------------------------------------
alias fabric="fabric-ai"

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
#  kubectl
# ------------------------------------------------
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgpw="kubectl get pods -o wide"
alias kgpa="kubectl get pods --all-namespaces"
alias kgd="kubectl get deployments"
alias kgs="kubectl get services"
alias kgn="kubectl get nodes"
alias kgno="kubectl get nodes -o wide"
alias kgns="kubectl get namespaces"
alias kcf="kubectl create -f"
alias kaf="kubectl apply -f"
alias kdf="kubectl delete -f"
alias kdp="kubectl describe pod"
alias kdd="kubectl describe deployment"
alias kds="kubectl describe service"
alias kdn="kubectl describe node"
alias kex="kubectl exec -it"
alias klo="kubectl logs"
alias klof="kubectl logs -f"
alias ked="kubectl edit deployment"
alias kep="kubectl edit pod"
alias kdel="kubectl delete"
alias kpf="kubectl port-forward"
alias kga="kubectl get all"
alias kgc="kubectl get configmaps"
alias kgs="kubectl get secrets"
alias ktc="kubectl top pod --containers"
alias ktn="kubectl top nodes"
alias ktp="kubectl top pods"
alias ka="kubectl apply"

# Helpers
alias kpurge="kubectl delete pods --field-selector status.phase=Failed --all-namespaces"
alias kwatchp="kubectl get pods -o wide --watch"
alias krolln="kubectl rollout restart deployment"
alias krh="kubectl rollout history"
alias krs="kubectl rollout status"
alias kru="kubectl rollout undo"
alias ksc="kubectl scale"

# ------------------------------------------------
#  kubectx & kubens
# ------------------------------------------------
alias kx="kubectx"
alias kxg="kubectx | grep"
alias kns="kubens"
alias knsg="kubens | grep"
alias kcd="kubectx && kubens"  # Change both context and namespace interactively
alias kctx="kubectx"
alias ksc="kubectx -c"  # Show current context
alias ksn="kubens -c"   # Show current namespace
alias kxd="kubectx docker-desktop"
alias kxm="kubectx minikube"

# ------------------------------------------------
#  k9s
# ------------------------------------------------
alias k9="k9s"
alias k9a="k9s --all-namespaces"
alias k9c="k9s --context"
alias k9n="k9s --namespace"
alias k9p="k9s --command pod"
alias k9d="k9s --command deploy"
alias k9s="k9s --command svc"
alias k9h="k9s help"
alias k9l="k9s info"  # List keyboard shortcuts and available resources
alias k9r="k9s --readonly"

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
#  Granted
# ------------------------------------------------
alias assume='source $(asdf which assume)'

# ------------------------------------------------
# Load antidote
# ------------------------------------------------
export ANTIDOTE_HOME="${HOME}/.cache/antidote"

set +ua
# shellcheck disable=SC1091
if [[ -n "${ZSH_VERSION:-}" && -f "${HOMEBREW_PREFIX}/opt/antidote/share/antidote/antidote.zsh" ]]; then
    # Load antidote directly rather than using autoload
    source "${HOMEBREW_PREFIX}/opt/antidote/share/antidote/antidote.zsh"

    # Set the root name of the plugins files (.txt and .zsh) antidote will use.
    zsh_plugins="${HOME}/.zsh_plugins"

    # Create a new plugins file if it doesn't exist.
    if [[ ! -f "${zsh_plugins}.txt" ]]; then
        touch "${zsh_plugins}.txt"
    fi

    # Generate a new static file whenever .zsh_plugins.txt is updated.
    if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
        antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
    fi

    # Source your static plugins file.
    source ${zsh_plugins}.zsh
fi
set -ua

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
# Set up Virtualenv Wrapper
# ------------------------------------------------
set +ua
if type virtualenvwrapper.sh &>/dev/null; then
    export WORKON_HOME="${HOME}/.virtualenvs"
    VIRTUALENVWRAPPER_PYTHON="$(asdf which python)"
    export VIRTUALENVWRAPPER_PYTHON
    export VIRTUALENVWRAPPER_VIRTUALENV="${HOMEBREW_PREFIX}/bin/virtualenv"
    export VIRTUALENVWRAPPER_VIRTUALENV_ARGS="--no-site-packages"
    export VIRTUALENVWRAPPER_HOOK_DIR="${HOME}/.virtualenvs/bin"

    source "${HOMEBREW_PREFIX}/bin/virtualenvwrapper.sh"
else
    # shellcheck disable=SC2016
    printf_warning 'virtualenv does not not seem to be installed (`brew install virtualenv virtualenvwrapper`)'
fi
set -ua

# Unset strict options, we only care about our code
set +ua

# vim: ft=zsh
