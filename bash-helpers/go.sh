# go.sh
log debug ""
log debug "$(printf_callout ["${BASH_SOURCE[0]}"])"

# lazy init goenv
function goenv_alias() {
	local go_cmds
	mapfile -t go_cmds <<-EOF
		        go
		        goenv
	EOF

	for cmd in "${go_cmds[@]}"; do
		cmd=$(printf "%s" "${cmd}" | trim)

		if [[ $1 == "create" ]]; then
			# shellcheck disable=SC2139
			alias "${cmd}"=goenv_lazy_init
		elif [[ $1 == "remove" ]]; then
			unalias "${cmd}" 2>/dev/null
		fi
	done
}

function goenv_lazy_init() {
    log debug "$(printf_callout Initalizing goenv...)"
	unset -f goenv_lazy_init

	printf_callout "%s\n" "goenv has not been initialized, initializing now..."
	goenv_alias remove
	eval "$(goenv init -)"

	printf_warning "%s\n" "goenv initialized, plese re-run the previosu command."
}

if [[ -z ${GOENV_ROOT:-} ]]; then
    goenv_alias create
fi
