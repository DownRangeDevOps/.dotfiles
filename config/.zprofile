# shellcheck shell=bash disable=SC1090,SC1091  # ignore refusal to follow dynamic paths

# -a: Export all functions to make them available in sub-shells
# -u: We should not use unbound variables
# -o pipefile: We should ensure pipelines fail if commands within them fail
#
# WARNING: Unset with +a and +u before sourcing third party libraries or they
# will export functions and throw errors
set -uao pipefail

# Uncomment to use the profiling module (`zprof`)
# zmodload zsh/zprof

# Globals
export PERSONAL_LAPTOP_USER="ryanfisher"
export DOTFILES_PREFIX="${HOME}/.dotfiles"
export CONFIG_FILES_PREFIX="${DOTFILES_PREFIX}/config"
export BASH_D_PATH="${DOTFILES_PREFIX}/bash.d"
export PATH="${DOTFILES_PREFIX}/bin:${PATH}" # my bins
export VIM_SESSION_FILE=".session.vim"
PHYSICAL_CPUS=$(( $(sysctl -n hw.physicalcpu) - 2 ))
LOGICAL_CPUS=$(( $(sysctl -n hw.logicalcpu) - 2 ))
export PHYSICAL_CPUS
export LOGICAL_CPUS

# Vale global config
export VALE_CONFIG_PATH="${HOME}/.dotfiles/config/vale/.vale.ini"
export VALE_STYLES_PATH="${HOME}/.dotfiles/config/vale/styles"

# Set default project tracker base URL
if [[ "$(whoami)" == "xjxf277" ]]; then
    export PROJECT_TRACKER_URL="https://grainger.atlassian.net/browse/"
else
    export PROJECT_TRACKER_URL="https://github.com/DownRangeDevOps/.dotfiles/issues/"
fi

# Reset path to always start fresh
export PATH=""

# Disable strictness
set +ua

# Set default paths
if [[ -n "${ZSH_VERSION:-}" ]]; then
    source /etc/zprofile
else
    source /etc/profile
fi

# Set base Homebrew paths
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi


# ------------------------------------------------
# Dependencies
# ------------------------------------------------
[[ -f "${BASH_D_PATH}/lib.sh" ]] && source "${BASH_D_PATH}/lib.sh"

safe_source "${BASH_D_PATH}/path.sh"
safe_source "${BASH_D_PATH}/bash.sh"
safe_source "${CONFIG_FILES_PREFIX}/.zaliases"

# log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Done, .bash_profile loaded."

# ------------------------------------------------
# Set key repeat settings
# ------------------------------------------------
# Set key repeat rate (lower = faster, 1 is fastest)
defaults write NSGlobalDomain KeyRepeat -int 2

# Set delay until repeat begins (lower = shorter delay, 10 is shortest)
defaults write NSGlobalDomain InitialKeyRepeat -int 20

# ------------------------------------------------
# Symlink dofiles
# ------------------------------------------------
LN_ARGS=(-s -f)
if [[ -f "${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin/ln" ]]; then
    LN_ARGS+=(-r)
fi

HOME_DOTFILES=(
    .default-gems
    .default-python-packages
    .editorconfig
    .fdignore
    .gemrc
    .gitconfig
    .inputrc
    .jshintrc
    .markdownlint.yaml
    .terraformrc
    .tmux.conf
    .tool-versions
    .yamlfix.toml
    .zaliases
    .zprofile
    .zsh_plugins.txt
    .zshenv
    .zshrc
)

for file in "${HOME_DOTFILES[@]}"; do
    if [[ ! -h "${HOME}/${file}" ]]; then
        ln "${LN_ARGS[@]}" "${HOME}/.dotfiles/config/${file}" "${HOME}/"
    fi
done

# Symlink config files and directories
[[ ! -h "${HOME}/.config/nvim" ]] && ln "${LN_ARGS[@]}" "${HOME}/.dotfiles/config/nvim" "${HOME}/.config/nvim"
[[ ! -h "${HOME}/.config/yamllint" ]] && ln "${LN_ARGS[@]}" "${HOME}/.dotfiles/config/yamllint" "${HOME}/.config/yamllint"

mkdir -p "${HOME}/.config/karabiner/assets/" 1>/dev/null
for file in $(command ls "${HOME}/.dotfiles/config/karabiner"); do
    if [[ ! -h "${HOME}/.config/karabiner/assets/complex_modifications/${file}" ]]; then
        ln "${LN_ARGS[@]}" "${HOME}/.dotfiles/config/karabiner/${file}" "${HOME}/.config/karabiner/assets/complex_modifications/${file}"
    fi
done

# ------------------------------------------------
#  Use my terminal definitions first, see `terminfo.md`
# ------------------------------------------------
export TERMINFO_DIRS="${HOME}/.terminfo:${TERMINFO_DIRS-/usr/share/terminfo}"

# ------------------------------------------------
# ripgrep
# ------------------------------------------------
export RIPGREP_CONFIG_PATH="$HOME/.dotfiles/config/.ripgreprc"
function rg() {
     "${HOMEBREW_PREFIX}/bin/rg" --threads="$(printf "%d" "${LOGICAL_CPUS}")" "$@"
}

# ------------------------------------------------
# fzf
# ------------------------------------------------
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

export FZF_DEFAULT_COMMAND="\
    ${HOMEBREW_PREFIX}/bin/fd \
    --hidden \
    --follow \
    --threads ${LOGICAL_CPUS} \
    --exclude '.git' \
    --exclue '.git' \
    --exclue '.svn' \
    --exclue '.hg' \
    --exclue 'node_modules' \
    --exclue 'vendor' \
    --exclue '__pycache__' \
    --exclue 'dist' \
    --exclue 'build' \
    --exclue 'target' \
    --exclue 'bin' \
    --exclue 'obj' \
    --exclue '.vscode' \
    --exclue '.idea' \
    --exclue '.DS_Store' \
    --exclue 'Thumbs.db' \
    --exclue '*.tmp' \
    --exclue '*.log' \
    --exclue '*.swp' \
    --exclue '*~' \
    --exclue '*.pyc' \
    --exclue '*.pyo' \
    --exclue '*.egg-info/*' \
    --exclue '.pytest_cache/*' \
    --exclue '.tox/*' \
    --exclue '.mypy_cache/*' \
    --exclue '*.class' \
    --exclue '.gradle/*' \
    --exclue '.mvn/*' \
    --exclue '*.min.js' \
    --exclue '*.bundle.js' \
    --exclue '.eslintcache' \
    --exclue 'coverage/*' \
    --exclue 'target/*' \
    --exclue 'cargo.lock' \
    --exclue 'go.sum' \
    "

# fzf Catppuccin theme
export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --color=selected-bg:#45475a \
    --color=border:#313244,label:#cdd6f4"

# ------------------------------------------------
# Set up Virtualenv Wrapper
# ------------------------------------------------
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

# ------------------------------------------------
#  Granted
# ------------------------------------------------
alias assume='source $(asdf which assume)'

# ------------------------------------------------
#  Set up direnv shell hook
# ------------------------------------------------
if [[ -n "$(command -v direnv)" ]]; then
    eval "$("${HOMEBREW_PREFIX}/bin/direnv" hook zsh)"
else
    print_warnining 'direnv does not seem to be installed (`brew install direnv`)'
fi

# ------------------------------------------------
# Enable ASDF
# ------------------------------------------------
if [[ -n "$(command -v asdf)" ]]; then
    export ASDF_PYAPP_DEFAULT_PYTHON_PATH="${HOME}/.asdf/shims/python"
    source "${HOMEBREW_PREFIX}/opt/asdf/libexec/asdf.sh"
else
    printf_warning 'ASDF does not seem to be installed: `brew install asdf`'
fi

# ------------------------------------------------
# Rebuild zsh auto-completions
# ------------------------------------------------
autoload -Uz compinit
compinit

export ZSH_PROFILE_SOURCED=1
# vim: ft=zsh
