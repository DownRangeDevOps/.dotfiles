log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  config
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading config..."

export BETTER_EXCEPTIONS=1 # python better exceptions
export PTPYTHON_CONFIG_HOME="${HOME}/.config/ptpython/"

# Pipx
export PIPX_DEFAULT_PYTHON="${HOME}/.pyenv/shims/python"
eval "$(register-python-argcomplete pipx)"

# ------------------------------------------------
#  aliases
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading alises..."

# alias rmlp=run_mega_linter_python
# alias gpt=generate_python_module_ctags

# ------------------------------------------------
#  overloads
# ------------------------------------------------
# function ptpython() {
#     local virtual_env
#     export VIRTUAL_ENV=${PWD}/ VIRTUALENV=$(pwd)/myenv pipx run ptpython
# }

# ------------------------------------------------
#  helpers
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

function __get_virtualenv_name() {
    if [[ ${VIRTUAL_ENV:-} ]]; then
        printf "%s\n" " $(basename "$VIRTUAL_ENV")"
    else
        printf "%s\n" ""
    fi
}

# Initalize pyenv (https://github.com/pyenv/pyenv)
log debug "[$(basename "${BASH_SOURCE[0]}")]: Initializing pyenv..."
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
export WORKON_HOME="${HOME}/.virtualenvs"
export PROJECT_HOME="${HOME}/dev"
export VIRTUALENVWRAPPER_WORKON_CD=1

set +u
eval "$(pyenv init -)"
add_to_path "prepend" "$(pyenv prefix)" # pyenv
set -u

function pyenv_init() {
    local last_cmd
    last_cmd=$(fc -l | tail -1 | cut -d ' ' -f 2-)

    printf_warning "pyenv-virtualenv has not been initialized, initializing now..." >&2

    # pyenv-virtualenv (https://github.com/pyenv/pyenv-virtualenv)
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Initializing virtualenv..."
    set +u
    eval "$(pyenv virtualenv-init -)"

    # pyenv-virtualenvwrapper (https://github.com/pyenv/pyenv-virtualenvwrapper)
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Initializing virtualenvwrapper..."
    pyenv virtualenvwrapper_lazy
    set -u

    $last_cmd
}

function pyenv_alias() {
    local virtualenv_cmds
    mapfile -t virtualenv_cmds <<EOF
add2virtualenv
allvirtualenv
cdproject
cdsitepackages
cdvirtualenv
cpvirtualenv
lssitepackages
lsvirtualenv
mkproject
mktmpenv
mkvirtualenv
rmvirtualenv
setvirtualenvproject
showvirtualenv
toggleglobalsitepackages
wipeenv
workon
EOF

    log debug "[$(basename "${BASH_SOURCE[0]}")]: ==> Managing aliases to pyenv_init"

    for cmd in "${virtualenv_cmds[@]}"; do
        if [[ ${1:-} == "create" ]]; then
            log debug "[$(basename "${BASH_SOURCE[0]}")]: Aliasing ${cmd} to pyenv_init"

            # shellcheck disable=SC2139
            alias "${cmd}=pyenv_init"
        elif [[ ${1:-} == "remove" ]]; then
            log debug "[$(basename "${BASH_SOURCE[0]}")]: Unaliasing ${virtualenv_cmds[*]}"

            # shellcheck disable=SC2139
            unalias "${virtualenv_cmds[@]}" 2>/dev/null
        else
            printf_error "pyenv_alias: unknown argument $1"
        fi
    done
}

# Alias virtualenv lazy loader
if [[ -z ${PYENV_VIRTUALENVWRAPPER_PYENV_VERSION:-} ]]; then
    pyenv_alias create
else
    pyenv_alias remove
fi

# Megalinter helper
function run_mega_linter_python() {
    # Prompt user
    prompt_to_continue "Remove the existing report directory?" || return 3

    rm -rf report

    mega-linter-runner -f python "${@}" .
}

function lpy() {
    SQLFLUFF=("--processes=$(($(sysctl -n hw.ncpu) - 2))" "--FIX-EVEN-UNPARSABLE" "--force")
    SQL_FORMATTER=("--language=postgresql" "--uppercase" "--lines-between-queries=1" "--indent=4")
    FLYNT=("--transform-concats" "--line-length=999")
    AUTOPEP8=("--in-place" "--max-line-length=88" "--recursive")
    AUTOFLAKE=("--remove-all-unused-imports" "--remove-duplicate-keys" "--in-place" "--recursive")
    PRETTIER=("--ignore-path=${HOME}/.config/prettier" "--write" "--print-width=88")
    MDFORMAT=("--number" "--wrap=80")
    ISORT=("--profile=black" "--skip-gitignore" "--trailing-comma" "--wrap-length=88" "--line-length=88" "--use-parentheses" "--ensure-newline-before-comments")
    BLACK=("--preview")

    mapfile -t ALL_FILES < <(rg --files --color=never)
    mapfile -t SQL_FILES < <(rg --files --color=never --glob '*.sql')

    printf_callout "Removing trailing whitespace..."
    printf "%s" "${ALL_FILES[@]}" | xargs -L 1 sed -E -i 's/\s*$//g' | indent_output

    printf_callout "Running sql-formatter fix with '${SQL_FORMATTER[*]}'..."
    printf "%s" "${SQL_FILES[@]}" | xargs -I {} -L 1 \
        sql-formatter "${SQL_FORMATTER[@]}" --output={} {} | indent_output

    printf_callout "Running sqlfluff fix with '${SQLFLUFF[*]}'..."
    [[ -n ${SQL_FILES[*]} ]] && sqlfluff fix "${SQLFLUFF[@]}" . | indent_output

    printf_callout "Running flynt with '${FLYNT[*]}'..."
    flynt "${FLYNT[@]}" . | indent_output

    printf_callout "Running autopep8 with '${AUTOPEP8[*]}'..."
    autopep8 "${AUTOPEP8[@]}" . | indent_output

    printf_callout "Running autoflake with '${AUTOFLAKE[*]}'..."
    autoflake "${AUTOFLAKE[@]}" . | indent_output

    printf_callout "Running prettier with '${PRETTIER[*]}'..."
    prettier "${PRETTIER[@]}" . | indent_output

    printf_callout "Running mdformat with '${MDFORMAT[*]}'..."
    mdformat "${MDFORMAT[@]}" . | indent_output

    printf_callout "Running isort with '${ISORT[*]}'..."
    isort "${ISORT[@]}" . | indent_output

    printf_callout "Running black with '${BLACK[*]}'..."
    black "${BLACK[@]}" . | indent_output
}