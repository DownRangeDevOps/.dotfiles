log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

if [[ "$(uname -m)" == "x86_64" ]]; then
    export N_PREFIX="/usr/local"
else
    export N_PREFIX="/opt/homebrew"
fi
