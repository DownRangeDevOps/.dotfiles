# vim: set ft=bash:
# go.sh
logger "" "[${BASH_SOURCE[0]}]"

# add go bins to path
export PATH="${PATH}:${GOPATH}/bin"

# lazy init
function goenv_lazy() {
    # shellcheck disable=SC2155
    local CMD
    CMD="$(fc -ln | tail -1 | trim)"

    printf "%s\n" "goenv has not been initialized, initializing now..."

    for cmd in ${go_cmds[@]}; do
        if [[ $(type -t ${cmd}) == "alias" ]]; then
            unalias ${cmd}
        fi
    done

    eval "$(goenv init -)"

    printf "%s\n" "Done. Running \`${CMD}\`..."
    $CMD
}

mapfile -t go_cmds <<-EOF
    go
    goenv
EOF

for cmd in ${go_cmds[@]}; do
    alias $cmd=goenv_lazy
done
