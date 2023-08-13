# vim: set ft=bash:
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
export HOMEBREW_GITHUB_API_TOKEN=811a3b56929faba4b429317da5752ff4d39afba6
# Homebrew bash completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
