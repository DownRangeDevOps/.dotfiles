log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  config
# ------------------------------------------------
export HOMEBREW_NO_AUTO_UPDATE=1

# ------------------------------------------------
#  aliases
# ------------------------------------------------
# Avoid linking against any shims
NO_SHIMS_PATH=$(printf "%s" "${PATH}" | sed -E 's,.*shims[^:]*:,,g')
alias brew='env PATH=${NO_SHIMS_PATH} brew'
