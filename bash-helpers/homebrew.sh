# homebrew.sh
log debug ""
log debug "$(printf_callout ["${BASH_SOURCE[0]}"])"

# ------------------------------------------------
#  aliases
# ------------------------------------------------
# avoid accidentally linking against a Pyenv-provided Python
# (see: https://github.com/pyenv/pyenv#installation)
if pyenv root > /dev/null; then
  path_without_pyenv_shims="${PATH//~\/.pyenv\/shims:/}"
    alias brew='env PATH="${path_without_pyenv_shims}" brew'
fi

# ------------------------------------------------
#  config
# ------------------------------------------------
export HOMEBREW_GITHUB_API_TOKEN="${SECRET_HOMEBREW_GITHUB_PAT}"
