# shellcheck shell=bash

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [$0]"
fi

# ------------------------------------------------
#  config
# ------------------------------------------------
export HOMEBREW_API_AUTO_UPDATE_SECS=$((60 * 60 * 24 * 7)) # Only auto-update once a week
export HOMEBREW_AUTO_UPDATE_SECS=$((60 * 60 * 24 * 7))     # Only auto-update once a week
