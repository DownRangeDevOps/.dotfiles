# shellcheck shell=bash

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]:-${(%):-%x}}]"
fi

# ------------------------------------------------
#  init
# ------------------------------------------------
"${HOMEBREW_PREFIX}/opt/asdf/libexec/asdf.sh"

# Notes:
# - Hard coded asdf bin path for speed
# - Made `asdf.sh` and `asds.ps1` +x
