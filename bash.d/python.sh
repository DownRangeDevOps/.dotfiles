# shellcheck shell=bash disable=SC1091

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [$0]"
fi

# ------------------------------------------------
#  config
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "$0")]: Loading config..."
fi

export BETTER_EXCEPTIONS=1 # python better exceptions
export PTPYTHON_CONFIG_HOME="${HOME}/.config/ptpython/"

# Pipx
export PIPX_DEFAULT_PYTHON="${HOME}/.asdf/shims/python"
eval "$(register-python-argcomplete --shell zsh pipx)" # auto-completion

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
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "$0")]: Loading helpers..."
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
