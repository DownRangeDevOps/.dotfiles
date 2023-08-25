# homebrew.sh
log debug ""
log debug "$(printf_callout ["${BASH_SOURCE[0]}"])"

# ------------------------------------------------
#  aliases
# ------------------------------------------------
# Avoid linking against any shims
NO_SHIMS_PATH=$(printf "%s" "${PATH}" | sed -e 's,.*shims[^:]*:,,g')
alias brew='env PATH=${NO_SHIMS_PATH} brew'

# ------------------------------------------------
#  config
# ------------------------------------------------
export HOMEBREW_GITHUB_API_TOKEN="${SECRET_HOMEBREW_GITHUB_PAT}"
