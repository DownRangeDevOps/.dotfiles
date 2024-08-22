# shellcheck shell=bash
script_name="cargo.sh"

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${script_name}]"
fi

# ------------------------------------------------
#  init
# ------------------------------------------------
safe_source "$HOME/.cargo/env"
