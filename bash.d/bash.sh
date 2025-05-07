# shellcheck shell=bash disable=SC1090,SC1091

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [$0]"
fi

# ------------------------------------------------
#  config
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "$0")]: Configuring environment..."
fi

# openssl
LDFLAGS_ARR=(
    "-L${HOMEBREW_PREFIX}/opt/openssl@3/lib"
    "-L${HOMEBREW_PREFIX}/opt/llvm/lib/unwind -lunwind"
    "-L${HOMEBREW_PREFIX}/opt/llvm/lib/c++"
    "-L${HOMEBREW_PREFIX}/opt/llvm/lib"
)
CPPFLAGS_ARR=(
    "-I${HOMEBREW_PREFIX}/opt/openssl@3/include"
    "-I${HOMEBREW_PREFIX}/opt/llvm/include"
    "-I${HOMEBREW_PREFIX}/opt/llvm/include/c++/v1/"
)
export LDFLAGS="${LDFLAGS_ARR[*]}"
export CPPFLAGS="${CPPFLAGS_ARR[*]}"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig"

# llvm
export LLVM_INCLUDE_FLAGS="-L${HOMEBREW_PREFIX}/"

# config
export AWS_ASSUME_ROLE_TTL=1h
export AWS_SESSION_TTL=12h
export ECLIPSE_HOME=/Applications/Eclipse.app/Contents/Eclipse/
export EDITOR=nvim
JAVA_HOME="$(asdf where java)"
export JAVA_HOME
export GROOVY_HOME=/usr/local/opt/groovy/libexec
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"
export VALUE_CONFIG_PATH="${HOME}/config/vale/.vale.ini"

# fzf (https://github.com/junegunn/fzf)
export FZF_DEFAULT_OPTS="--history=${HOME}/.fzf_history"
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ------------------------------------------------
#  helpers
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "$0")]: Loading helpers..."
fi

function find_replace() {
    rg "$1" --files-with-matches --follow | xargs sed --in-place --follow-symlinks --regexp-extended "s/\b$1\b/$2/g"
}

function is_subsh() {
    local shell_level="${SHLVL}"

    if [[ -n "${NVIM:-}" ]]; then
        shell_level="$((SHLVL - 1))"
    fi

    if [[ "${shell_level}" -gt 1 ]]; then
        printf "%s" " (${shell_level}) "
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
        lsopts+=("--icons=auto" "--header" "--modified" "--git" "--smart-group" "--binary" "--time-style=relative")
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
    log debug "[$(basename "$0")]: Configuring utils and loading util functions..."
fi

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

function markdownlint-cli2() {
    command markdownlint-cli2 "$@" --config "${HOME}/.markdownlint.yaml"
}

function yamlfix() {
    command yamlfix --config-file "${HOME}/.dotfiles/config/.yamlfix.toml" "$@"
}

# Generate password hash for MySQL
function mysqlpw() {
    $(pyenv which python) -c '
        from hashlib import sha1
        import getpass
        print \"*\" + sha1(sha1(getpass.getpass(\"New MySQL Password:\")).digest()).hexdigest()
        '
}

function nvim() {
    if [[ -f "${VIM_SESSION_FILE}" ]]; then
        command nvim -S "${VIM_SESSION_FILE}" "$@"
    elif [[ -f "./.session.vim" ]]; then
        command nvim -S ./.session.vim "$@"
    else
        command nvim "$@"
    fi
}

# ------------------------------------------------
# bash.d
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "$0")]: Loading bash.d files..."
fi

# Source the remaining `bash.d/*.sh` files
if [[ -n "${ZSH_VERSION:-}" ]]; then
    {
        for file in "${BASH_D_PATH}"/*(N.); do
            if [[ ! "${file}" =~ (lib.sh|path.sh|bash.sh) ]]; then
                if [[ -n "${DEBUG:-}" ]]; then
                    log debug "[$(basename "$0")]: Loading ${file} ..."
                fi

                safe_source "${file}"
            fi
        done
    }
else
    {
        shopt -s nullglob # protect against empty dir

        for file in "${BASH_D_PATH}"/*; do
            if [[ -f "${file}" && ! "${file}" =~ (lib.sh|path.sh|bash.sh) ]]; then
                if [[ -n "${DEBUG:-}" ]]; then
                    log debug "[$(basename "$0")]: Loading ${file} ..."
                fi

                safe_source "${file}"
            fi
        done

        shopt -u nullglob # reset
    }
fi
