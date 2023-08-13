# homebrew.sh
logger "" "[${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  aliases
# ------------------------------------------------
# avoid accidentally linking against a Pyenv-provided Python
# (see: https://github.com/pyenv/pyenv#installation)
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'

# ------------------------------------------------
#  config
# ------------------------------------------------
export HOMEBREW_GITHUB_API_TOKEN="${SECRET_HOMEBREW_GITHUB_PAT}"
