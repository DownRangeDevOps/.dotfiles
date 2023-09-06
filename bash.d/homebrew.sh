log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  config
# ------------------------------------------------
export HOMEBREW_API_AUTO_UPDATE_SECS=$(( 60 * 60 * 24 * 7 )) # Only auto-update once a week
export HOMEBREW_AUTO_UPDATE_SECS=$(( 60 * 60 * 24 * 7 )) # Only auto-update once a week
