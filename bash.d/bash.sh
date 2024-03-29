# shellcheck shell=bash disable=SC1090,SC1091

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]:-${(%):-%x}}]"
fi

# ------------------------------------------------
#  config
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Configuring environment..."
fi

# llvm
export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/llvm/lib -L${HOMEBREW_PREFIX}/opt/llvm/lib/c++ -Wl,-rpath,${HOMEBREW_PREFIX}/opt/llvm/lib/c++"
export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/llvm/include -I${HOMEBREW_PREFIX}/opt/llvm/include/c++/v1/"
export LLVM_INCLUDE_FLAGS="-L${HOMEBREW_PREFIX}/"

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
    log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Loading helpers..."
fi

function find_replace() {
    rg "$1" -l | xargs sed -i -E "s/\b$1\b/$2/g"
}

function is_subsh() {
    local shell_level="${SHLVL}"

    if [[ -n "${NVIM:-}" ]]; then
        shell_level="$((SHLVL - 1))"
    fi

    if [[ "${shell_level}" -gt 1 ]]; then
        printf "%s" " [${shell_level}] "
    fi
}

function list_dir() {
    local gnu_ls="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin/ls"
    local eza="${HOMEBREW_PREFIX}/bin/eza"
    local lsopts=("--color=auto" "--almost-all")

    if [[ ${1:-} == "--long" ]]; then
        shift
        lsopts+=("-l" "--classify" "--group-directories-first")
    fi

    if [[ -f ${eza} ]]; then
        lsopts+=("--icons=auto" "--header" "--modified" "--git")
        ${eza} "${lsopts[@]}" "$@"
    else
        lsopts+=("--no-group" "--size" "--human-readable")

        if [[ -f ${gnu_ls} ]]; then
            printf_warning "eza not found at ${eza}, falling back to ${gnu_ls}"
            ${gnu_ls} "${lsopts[@]}" "$@"
        else
            printf_warning "GNU ls not found at ${gnu_ls}, falling back to /bin/ls"
            /bin/ls "${lsopts[@]}" "$@"
        fi
    fi
}

# ------------------------------------------------
#  utils
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Configuring utils and loading util functions..."
fi

function nvim() {
    # if [[ -n ${RBENV_INITALIZED:-} ]]; then
    #     rbenv_init &>/dev/null
    # fi
    #
    # if [[ -n "${PYENV_INITALIZED:-}" ]]; then
    #     pyenv_init &>/dev/null
    # fi
    #
    if [[ "${NVIM_SESSION_FILE_PATH:-}" ]]; then
        touch "${NVIM_SESSION_FILE_PATH:-}"
        command nvim -S "${NVIM_SESSION_FILE_PATH:-}" "$@"
    else
        command nvim "$@"
    fi
}

function rg() {
    "${HOMEBREW_PREFIX}/bin/rg" \
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
    log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Configuring bash completions..."
fi

set +ua
source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"

# NOTE: overwrites PS1, source it before setting custom PS1
if [[ -n "${ZSH_VERSION:-}" ]]; then
    source "${HOMEBREW_PREFIX}/share/google-cloud-sdk/path.zsh.inc"
    source "${HOMEBREW_PREFIX}/share/google-cloud-sdk/completion.zsh.inc"
else
    source "${HOMEBREW_PREFIX}/share/google-cloud-sdk/path.bash.inc"
    source "${HOMEBREW_PREFIX}/share/google-cloud-sdk/completion.bash.inc"
fi
set -ua

if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Loading bash.d files..."
fi

if [[ -n "${ZSH_VERSION:-}" ]]; then
    {
        for file in "${BASH_D_PATH}"/*(N); do
            if [[ ! "${file}" =~ (lib.sh|path.sh|bash.sh) ]]; then
                if [[ -n "${DEBUG:-}" ]]; then
                    log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Loading ${file} ..."
                fi

                safe_source "${file}"
            fi
        done
    }
else
    {
        shopt -s nullglob # protect against empty dir

        for file in "${BASH_D_PATH}"/*; do
            if [[ ! "${file}" =~ (lib.sh|path.sh|bash.sh) ]]; then
                if [[ -n "${DEBUG:-}" ]]; then
                    log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Loading ${file} ..."
                fi

                safe_source "${file}"
            fi
        done

        shopt -u nullglob # reset
    }
fi
