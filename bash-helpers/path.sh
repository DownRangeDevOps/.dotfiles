# Reset PATH then add bins
function set_path() {
	log debug "[$(basename "${BASH_SOURCE[0]}")]: Resetting PATH"

	local brew_prefix
    local rbenv_prefix
    local goenv_prefix
	local gnu_tools=("gnu-tar" "gnu-which" "gnu-sed" "grep" "coreutils" "findutils" "make")
	local compilers=("llvm/bin")

	if brew --version >/dev/null 2<&1; then brew_prefix="$(brew --prefix)"; fi
	if rbenv --version >/dev/null 2<&1; then rbenv_prefix="$(rbenv prefix)"; fi
	if goenv --version >/dev/null 2<&1; then goenv_prefix="$(goenv prefix)"; fi

	export PATH=""      # Reset
	source /etc/profile # Base
	if [[ -z ${brew_prefix} ]]; then
		add_to_path "prepend" "${brew_prefix}/bin"     # Homebrew
		add_to_path "prepend" "${brew_prefix}/lib"     # Homebrew
		add_to_path "prepend" "${brew_prefix}/include" # Homebrew
		add_to_path "prepend" "${brew_prefix}/opt"     # Homebrew
		add_to_path "prepend" "${brew_prefix}/sbin"    # Homebrew
	fi

	for tool in "${gnu_tools[@]}"; do
		add_to_path prepend "${brew_prefix}/opt/${tool}/libexec/gnubin" # Homebrew gnu tools
		add_to_path prepend "${brew_prefix}/opt/${tool}/libexec/gnubin" # Homebrew gnu tools
	done

	for path in "${compilers[@]}"; do
		add_to_path prepend "${brew_prefix}/opt/${path}" # llvm
	done

	add_to_path "prepend" "/opt/X11/bin"       # X11
	add_to_path "append" "${HOME}/.local/bin"  # Ansible
	add_to_path "append" "${HOME}/.cabal/bin/" # Haskell

	if rbenv --version >/dev/null 2>&1; then add_to_path "prepend" "${rbenv_prefix}/bin"; fi # rbenv

	if pyenv --version >/dev/null 2>&1; then
		add_to_path "prepend" "$(pyenv prefix)" # pyenv
		pipx ensurepath >/dev/null 2>&1         # pipx
	fi

	if goenv --version >/dev/null 2>&1; then
		add_to_path "prepend" "${goenv_prefix}/bin" # Go binaries
	fi
}
set_path
