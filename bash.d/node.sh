# shellcheck shell=bash

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]}]"
fi

if [[ "$(uname -m)" == "x86_64" ]]; then
    export N_PREFIX="/usr/local"
else
    export N_PREFIX="/opt/homebrew"
fi
