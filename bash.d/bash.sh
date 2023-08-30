# shellcheck disable=SC1090,SC1091
log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

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
export LDFLAGS="-L${BREW_PREFIX}/opt/llvm/lib && -L${BREW_PREFIX}/opt/llvm/lib/c++ -Wl,-rpath,${BREW_PREFIX}/opt/llvm/lib/c++"
export CPPFLAGS="-I${BREW_PREFIX}/opt/llvm/include && -I${BREW_PREFIX}/opt/llvm/include/c++/v1/"
export LLVM_INCLUDE_FLAGS="-L${BREW_PREFIX}/"

# config
export AWS_ASSUME_ROLE_TTL=1h
export AWS_SESSION_TTL=12h
export ECLIPSE_HOME=/Applications/Eclipse.app/Contents/Eclipse/
export EDITOR=nvim
export GROOVY_HOME=/usr/local/opt/groovy/libexec
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"

# fzf (https://github.com/junegunn/fzf)
export FZF_DEFAULT_OPTS="--history=${HOME}/.fzf_history"
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ------------------------------------------------
#  helpers
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

function list_dir_cont() {
    local gnu_ls=/usr/local/opt/coreutils/libexec/gnubin/ls
    local lsopts=("--color=auto" "--almost-all")

    if [[ ${1:-} == "--long" ]]; then
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

# ------------------------------------------------
# bash.d sourcing
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading gcloud ..."

# overwrites PS1 so do it first
set +u
source "${BREW_PREFIX}/share/google-cloud-sdk/path.bash.inc"
source "${BREW_PREFIX}/share/google-cloud-sdk/completion.bash.inc"
set -u

log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading bash.d files..."
{
    shopt -s nullglob # protect against empty dir

    for file in "${BASH_D_PATH}"/*; do
        if [[ ! "${file}" =~ (lib.sh|path.sh|bash.sh) ]]; then
            log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading ${file} ..."

            source "${file}"
        fi
    done

    shopt -u nullglob # reset
}

# jump around
# Z_SH="${BREW_PREFIX}/etc/profile.d/z.sh"
# if [[ -f "${Z_SH}" ]]; then
#     set +u
#     source "${Z_SH}"
#     set -u
# fi

# .bashrc
if [[ -f "${HOME}/.bashrc" ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading .bashrc..."

    source "${HOME}/.bashrc"

    log debug "[$(basename "${BASH_SOURCE[0]}")]: Done."
fi
