# Add the direnv hook to PROMPT_COMMAND
log debug ""
log debug "$(printf_callout "[${BASH_SOURCE[0]}]")"
log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading direnv hook..."
eval "$(direnv hook bash)"
