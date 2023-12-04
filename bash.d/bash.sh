# shellcheck shell=bash disable=SC1090,SC1091

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]}]"
fi

# ------------------------------------------------
#  config
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Configuring environment..."
fi

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
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."
fi

function is_subsh() {
    local shell_level="${SHLVL}"

    if [[ -n "${NVIM_LOG_FILE:-}" ]]; then
        shell_level="$(( SHLVL - 1 ))"
    fi

    if [[ "${shell_level}" -gt 1 ]]; then
        printf "%s" " [${shell_level}] "
    fi
}

function list_dir() {
    local gnu_ls="${BREW_PREFIX}/opt/coreutils/libexec/gnubin/ls"
    local lsopts=("--color=auto" "--almost-all")

    if [[ ${1:-} == "--long" ]]; then
        shift
        lsopts+=("-l" "--classify" "--no-group" "--size" "--human-readable" "--group-directories-first")
    fi

    if [[ -f ${gnu_ls} ]]; then
        ${gnu_ls} "${lsopts[@]}" "$@"
    else
        printf_warning "GNU ls not found at ${gnu_ls}, falling back to /bin/ls"
        /bin/ls "${lsopts[@]}" "$@"
    fi
}

# ------------------------------------------------
#  utils
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Configuring utils and loading util functions..."
fi

function nvim() {
    rbenv init &>/dev/null
    pyenv &>/dev/null

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

function yamlfix() {
    command yamlfix -c ~/.yamlfix.toml "$@"
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
# bash.d
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Configuring bash completions..."
fi

set +ua
source "${BREW_PREFIX}/etc/profile.d/bash_completion.sh"

# NOTE: overwrites PS1, source it before setting custom PS1
source "${BREW_PREFIX}/share/google-cloud-sdk/path.bash.inc"
source "${BREW_PREFIX}/share/google-cloud-sdk/completion.bash.inc"
set -ua

if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading bash.d files..."
fi

{
    shopt -s nullglob # protect against empty dir

    for file in "${BASH_D_PATH}"/*; do
        if [[ ! "${file}" =~ (lib.sh|path.sh|bash.sh) ]]; then
            if [[ -n "${DEBUG:-}" ]]; then
                log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading ${file} ..."
            fi

            safe_source "${file}"
        fi
    done

    shopt -u nullglob # reset
}

# .bashrc
if [[ -f "${HOME}/.bashrc" ]]; then
    if [[ -n "${DEBUG:-}" ]]; then
        log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading .bashrc..."
    fi

    safe_source "${HOME}/.bashrc"

    if [[ -n "${DEBUG:-}" ]]; then
        log debug "[$(basename "${BASH_SOURCE[0]}")]: Done."
    fi

fi
