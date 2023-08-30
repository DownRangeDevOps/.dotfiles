# lazy load thefuck
if [[ -n ${TF_ALIAS:-} ]]; then
    unalias fuck=tf_init
else
    alias fuck=tf_init
fi

function tf_init() {
    unalias fuck=tf_init
    set +u
    eval "$(thefuck --alias)"
    set -u
    fuck "$@"
}
