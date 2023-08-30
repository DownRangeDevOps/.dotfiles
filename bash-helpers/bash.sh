# shellcheck disable=SC1090,SC1091
# logger is slow, avoid sourcing it unless we need it for now

# Source these first as they're dependencies atm
source "${HOME}/.dotfiles/bash-helpers/lib.sh"
source "${HOME}/.dotfiles/bash-helpers/path.sh"

# ------------------------------------------------
if [[ ${DEBUG:-} -eq 1 ]]; then
    source "${HOME}/.dotfiles/lib/log.sh"

    # log.sh sets -u which is too strict for many dependencies
    set +u

    log debug ""
    log debug "$(printf_callout ["${BASH_SOURCE[0]}"])"
else
    function log() {
        true
    }
fi

# overwrites PS1 so do it first
source /usr/local/share/google-cloud-sdk/path.bash.inc
source /usr/local/share/google-cloud-sdk/completion.bash.inc

# ------------------------------------------------
#  aliases
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating aliases..."

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
alias ls="list_dir_cont"
alias ll="list_dir_cont --long"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ..r="cd \$(__git_project_root)"
alias ..~="cd \${HOME}"
alias ctags="\${BREW_PREFIX}/bin/ctags"

# Squeltch egrep warnings
alias egrep="grep -E"

# ------------------------------------------------
#  config
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Configuring enviornment..."


# llvm
LDFLAGS="-L${BREW_PREFIX}/opt/llvm/lib && -L${BREW_PREFIX}/opt/llvm/lib/c++ -Wl,-rpath,${BREW_PREFIX}/opt/llvm/lib/c++" export LDFLAGS
CPPFLAGS="-I${BREW_PREFIX}/opt/llvm/include && -I${BREW_PREFIX}/opt/llvm/include/c++/v1/" export CPPFLAGS
LLVM_INCLUDE_FLAGS="-L${BREW_PREFIX}/" && export LLVM_INCLUDE_FLAGS

# config
export AWS_ASSUME_ROLE_TTL=1h
export AWS_SESSION_TTL=12h
export ECLIPSE_HOME=/Applications/Eclipse.app/Contents/Eclipse/
export EDITOR=nvim
export GROOVY_HOME=/usr/local/opt/groovy/libexec
export HOMEBREW_GITHUB_API_TOKEN=811a3b56929faba4b429317da5752ff4d39afba6
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"

# fzf (https://github.com/junegunn/fzf)
FZF_DEFAULT_OPTS="--history=${HOME}/.fzf_history" && export FZF_DEFAULT_OPTS
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ------------------------------------------------
#  helpers
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

function list_dir_cont() {
    local gnu_ls=/usr/local/opt/coreutils/libexec/gnubin/ls
    local lsopts=("--color=auto" "--almost-all")

    if [[ $1 == "--long" ]]; then
        shift
        lsopts+=("-l" "--classify" "--no-group" "--size" "--human-readable")
    fi

    if [[ -f ${gnu_ls} ]]; then
        ${gnu_ls} "${lsopts[@]}" "$@"
    else
        printf_error "GNU ls not found at ${gnu_ls}, falling back to /bin/ls"
        /bin/ls "${lsopts[@]}" "$@"
    fi
}

# ------------------------------------------------
#  utils
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Configuring utils and loading util functions..."
function nvim() {
    if [[ -w ${NVIM_SESSION_FILE_PATH:-} ]]; then
        command nvim -S "${NVIM_SESSION_FILE_PATH}" "$@"
    else
        command nvim "$@"
    fi
}

function rg() {
    "${BREW_PREFIX}/bin/rg" \
        --follow \
        --hidden \
        --no-config \
        --smart-case \
        --colors 'match:style:bold' \
        --colors 'match:fg:205,214,244' \
        --colors 'match:bg:62,87,103' \
        --glob '!.git' \
        "$@"
}

# Generate password hash for MySQL
function mysqlpw() {
    $(pyenv which python) -c '
        from hashlib import sha1
        import getpass
        print \"*\" + sha1(sha1(getpass.getpass(\"New MySQL Password:\")).digest()).hexdigest()
        '
}

log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading helper files..."
# shellcheck disable=SC1091
{
    # NOTE: These are sourced at the top of the file, here as a reminder
    # source "${HOME}/.dotfiles/bash-helpers/lib.sh"
    # source "${HOME}/.dotfiles/bash-helpers/path.sh"
    # source "${HOME}/.dotfiles/bash-helpers/bash.sh"

    source "${HOME}/.dotfiles/bash-helpers/ansible.sh"    # Ansible helpers
    source "${HOME}/.dotfiles/bash-helpers/aws.sh"        # aws helpers
    source "${HOME}/.dotfiles/bash-helpers/direnv.sh"     # Terraform helpers
    source "${HOME}/.dotfiles/bash-helpers/docker.sh"     # Docker helpers
    source "${HOME}/.dotfiles/bash-helpers/git.sh"        # git helpers
    source "${HOME}/.dotfiles/bash-helpers/go.sh"         # Golang helpers
    source "${HOME}/.dotfiles/bash-helpers/kubernetes.sh" # K8s helpers
    source "${HOME}/.dotfiles/bash-helpers/ls_colors.sh"  # ls colors
    source "${HOME}/.dotfiles/bash-helpers/osx.sh"        # osx helpers
    source "${HOME}/.dotfiles/bash-helpers/ps1.sh"        # set custom PS1
    source "${HOME}/.dotfiles/bash-helpers/python.sh"     # python
    source "${HOME}/.dotfiles/bash-helpers/ruby.sh"       # python helpers
    source "${HOME}/.dotfiles/bash-helpers/terraform.sh"  # Terraform helpers
    source "${HOME}/.dotfiles/bash-helpers/thefk.sh"      # The Fk helpers

    # source "${BREW_PREFIX}/etc/profile.d/z.sh"            # z cd auto completion
}

# .bashrc
if [[ -f "${HOME}/.bashrc" ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading .bashrc..."

    # shellcheck source=/Users/ryanfisher/.bashrc
    source "${HOME}/.bashrc"
fi

log debug "[$(basename "${BASH_SOURCE[0]}")]: Done." ""
