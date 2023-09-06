log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# shellcheck disable=SC1090,SC1091
log debug "[$(basename "${BASH_SOURCE[0]}")]: Initializing direnv..."

# Add the direnv hook to PROMPT_COMMAND
eval "$(direnv hook bash)"
