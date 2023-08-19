# python.sh
log debug ""
log debug "$(printf_callout ["${BASH_SOURCE[0]}"])"

# ------------------------------------------------
#  config
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading config..."

export BETTER_EXCEPTIONS=1  # python better exceptions
export PTPYTHON_CONFIG_HOME="$HOME/.config/ptpython/"

# Pyenv (https://github.com/pyenv/pyenv)
# pyenv-virtualenv (https://github.com/pyenv/pyenv-virtualenv)
# pyenv-virtualenvwrapper (https://github.com/pyenv/pyenv-virtualenvwrapper)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
export WORKON_HOME="$HOME/.virtualenvs"
export PROJECT_HOME="$HOME/dev"
export VIRTUALENVWRAPPER_WORKON_CD=1

# Pipx
export PIPX_DEFAULT_PYTHON="${HOME}/.pyenv/shims/python"


# ------------------------------------------------
#  aliases
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading alises..."

# alias rmlp=run_mega_linter_python
# alias gpt=generate_python_module_ctags

# ------------------------------------------------
#  helpers
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

function get_virtualenv_name () {
    if [[ $VIRTUAL_ENV ]]; then
        printf "%s\n" " $(basename "$VIRTUAL_ENV")"
    else
        printf "%s\n" ""
    fi
}

# Initalize pyenv
function pyenv_init() {
    local CMD
    CMD=$1
    echo "$@"
    shift

    unset -f pyenv_init
    unalias "pyenv" 2>/dev/null
    pyenv_alias remove
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    pyenv virtualenvwrapper
    export PYENV_INITIALIZED=true

    "${CMD}" "$@"
}


function pyenv_alias() {
    local virtualenv_cmds
    mapfile -t virtualenv_cmds <<-EOF
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
        pyenv
EOF

    for name in "${virtualenv_cmds[@]}"; do
        name=$(printf "%s\n" "${name}" | trim)

        if [[ $1 == "create" ]]; then
            # shellcheck disable=SC2139
            alias "${name}=pyenv_init"
        elif [[ $1 == "remove" ]]; then
            # shellcheck disable=SC2139
            unalias "${name}" 2>/dev/null
        fi
    done
}

# Lazy pyenv loader

if ${PYENV_INITIALIZED}; then
    pyenv_alias remove
else
    pyenv_alias create
fi

# function ptpython() {
#     local virtual_env
#     export VIRTUAL_ENV=${PWD}/ VIRTUALENV=$(pwd)/myenv pipx run ptpython
# }

# function run_mega_linter_python() {
#     # Prompt user
#     prompt_to_continue "Remove the existing report directory?" || return 3
#
#     rm -rf report
#
#     mega-linter-runner -f python "${@}" .
# }

# function lpy() {
#     SQLFLUFF=("--processes=$(($(sysctl -n hw.ncpu) - 2))" "--FIX-EVEN-UNPARSABLE" "--force")
#     SQL_FORMATTER=("--language=postgresql" "--uppercase" "--lines-between-queries=1" "--indent=4")
#     FLYNT=("--transform-concats" "--line-length=999")
#     AUTOPEP8=("--in-place" "--max-line-length=88" "--recursive")
#     AUTOFLAKE=("--remove-all-unused-imports" "--remove-duplicate-keys" "--in-place" "--recursive")
#     PRETTIER=("--ignore-path=$HOME/.config/prettier" "--write" "--print-width=88")
#     MDFORMAT=("--number" "--wrap=80")
#     ISORT=("--profile=black" "--skip-gitignore" "--trailing-comma" "--wrap-length=88" "--line-length=88" "--use-parentheses" "--ensure-newline-before-comments")
#     BLACK=("--preview")
#
#     mapfile -t ALL_FILES < <(rg --files --color=never)
#     mapfile -t SQL_FILES < <(rg --files --color=never --glob '*.sql')
#
#     header "Removing trailing whitespace..."
#     printf "%s" "${ALL_FILES[@]}" | xargs -L 1 sed -E -i 's/\s*$//g' | indent_output
#
#     header "Running sql-formatter fix with '${SQL_FORMATTER[*]}'..."
#     printf "%s" "${SQL_FILES[@]}" | xargs -I {} -L 1 \
#             sql-formatter "${SQL_FORMATTER[@]}" --output={} {} | indent_output
#
#     header "Running sqlfluff fix with '${SQLFLUFF[*]}'..."
#     [[ -n ${SQL_FILES} ]] && sqlfluff fix "${SQLFLUFF[@]}" . | indent_output
#
#     header "Running flynt with '${FLYNT[*]}'..."
#     flynt "${FLYNT[@]}" . | indent_output
#
#     header "Running autopep8 with '${AUTOPEP8[*]}'..."
#     autopep8 "${AUTOPEP8[@]}" . | indent_output
#
#     header "Running autoflake with '${AUTOFLAKE[*]}'..."
#     autoflake "${AUTOFLAKE[@]}" . | indent_output
#
#     header "Running prettier with '${PRETTIER[*]}'..."
#     prettier "${PRETTIER[@]}" . | indent_output
#
#     header "Running mdformat with '${MDFORMAT[*]}'..."
#     mdformat "${MDFORMAT[@]}" . | indent_output
#
#     header "Running isort with '${ISORT[*]}'..."
#     isort "${ISORT[@]}" . | indent_output
#
#     header "Running black with '${BLACK[*]}'..."
#     black "${BLACK[@]}" . | indent_output
# }

# function get_python_module_paths() {
#     python -c "import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))"
# }

# function generate_python_module_ctags() {
#     read -r -a PYTHON_PATH  <<< "$(get_python_module_paths)"
#
#     rm -f ./tags
#     ctags -R \
#         --fields=+l \
#         --python-kinds=-i \
#         --exclude='*.pxd' \
#         --exclude='*.pxy' \
#         -f ./tags . "${PYTHON_PATH[@]}"
# }
