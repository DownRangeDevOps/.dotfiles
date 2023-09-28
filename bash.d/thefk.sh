log debug ""
log debug "==> [${BASH_SOURCE[0]}]"

# lazy load thefuck
if [[ -n ${TF_ALIAS:-} ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Removing thefuck alias..."
    unalias fuck=tf_init
else
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating thefuck alias..."
    alias fuck=tf_init
fi

function tf_init() {
    log debug "[$(basename "${BASH_SOURCE[0]}")]: Initializing thefuck..."
    unalias fuck=tf_init

    set +au
    eval "$(thefuck --alias)"
    set -au

    fuck "$@"
}
