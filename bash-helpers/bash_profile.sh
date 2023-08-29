# shellcheck disable=SC1090,SC1091

# logger is slow, avoid sourcing it unless we need it for now
if [[ ${DEBUG:-} -eq 1 ]]; then
	source "${HOME}/.dotfiles/lib/log.sh"

	# log.sh sets -u which is too strict for many dependencies
	set +u

	log debug ""
	log debug "$(printf_callout ["${BASH_SOURCE[0]}"])"
else
	function log() {
		true
	}
fi

# Source these first as they're dependencies atm
source "${HOME}/.dotfiles/bash-helpers/lib.sh"
source "${HOME}/.dotfiles/bash-helpers/path.sh"
source "${HOME}/.dotfiles/bash-helpers/bash.sh"

# ------------------------------------------------
#  aliases
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Creating aliases..."

# auto on yubiswitch
alias ssh="osascript -e 'tell application \"yubiswitch\" to KeyOn' && ssh"
alias scp="osascript -e 'tell application \"yubiswitch\" to KeyOn' && scp"

alias c="clear"
alias ebash='nvim ${HOME}/.bash_profile'
alias ec=ebash
alias genpasswd="openssl rand -base64 32"
alias myip="curl icanhazip.com"
alias sb='source ${HOME}/.bash_profile'
alias vim="nvim"

# safety
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
set -o noclobber

# tmux & tmuxinator
alias tmux='tmux -2'              # Force 256 colors in tmux
alias tks='tmux kill-session -t ' # easy kill tmux session
alias rc='reattach-to-user-namespace pbcopy'

# Generate password hash for MySQL
alias mysqlpw="/usr/bin/python -c 'from hashlib import sha1; import getpass; print \"*\" + sha1(sha1(getpass.getpass(\"New MySQL Password:\")).digest()).hexdigest()'"

# Info
alias ls="list_dir_cont"
alias ll="list_dir_cont --long"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ..r="cd \$(__git_project_root)"
alias ..~="cd \${HOME}"
alias ctags="\$(brew --prefix)/bin/ctags"

# Squeltch egrep warnings
alias egrep="grep -E"

# ------------------------------------------------
#  config
# ------------------------------------------------
log debug "[$(basename "${BASH_SOURCE[0]}")]: Configuring enviornment..."

# Use vi mode on command line
set -o vi
bind '"jj":vi-movement-mode'

# Always append to ~/.bash_history
shopt -s histappend

# Disable flow control commands (keeps C-s from freezing everything)
stty start undef
stty stop undef

# History
history -a
history -n

# color output for `ls`
export LS_COLORS='rs=0:di=1;35:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'

# config
LDFLAGS="-L$(brew --prefix)/llvm/lib" && export LDFLAGS
CPPFLAGS="-I$(brew --prefix)/llvm/include" && export CPPFLAGS
LLVM_INCLUDE_FLAGS="-L$(brew --prefix)/" && export LLVM_INCLUDE_FLAGS
export AWS_ASSUME_ROLE_TTL=1h
export AWS_SESSION_TTL=12h
export ECLIPSE_HOME=/Applications/Eclipse.app/Contents/Eclipse/
export EDITOR=nvim
export GROOVY_HOME=/usr/local/opt/groovy/libexec
export HOMEBREW_GITHUB_API_TOKEN=811a3b56929faba4b429317da5752ff4d39afba6
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"

# fzf (https://github.com/junegunn/fzf)
export FZF_DEFAULT_OPTS="--history=${HOME}/.fzf_history"
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ------------------------------------------------
#  utils
# ------------------------------------------------
# log debug "[$(basename "${BASH_SOURCE[0]}")]: Configuring utils and loading util functions..."
# function nvim() {
# 	# load the nvim venv if not already
# 	if [[ ! ${VIRTUAL_ENV} =~ /nvim$ ]]; then
# 		workon nvim
# 	fi
#
# 	if [[ -w ${NVIM_SESSION_FILE_PATH} ]]; then
# 		command nvim -S "${NVIM_SESSION_FILE_PATH:-}" "$@"
# 	else
# 		command nvim "$@"
# 	fi
# }

alias grep=rg
alias ag=rg
function rg() {
	"$(brew --prefix)/bin/rg" \
		--follow \
		--hidden \
		--no-config \
		--smart-case \
		--colors 'match:style:bold' \
		--colors 'match:fg:156,201,159' \
		--colors 'match:bg:24,64,43' \
		--glob '!.git' \
		"$@"
}

# lazy load thefuck
if [[ -n ${TF_ALIAS:-} ]]; then
	unalias fuck=tf_init
else
	alias fuck=tf_init
fi

function tf_init() {
	unalias fuck=tf_init
	eval "$(thefuck --alias)"
	fuck "$@"
}

log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading helper files..."
# shellcheck disable=SC1091
{
	# NOTE: These are sourced at the top of the file, here as a reminder
    # source "${HOME}/.dotfiles/bash-helpers/lib.sh"
    # source "${HOME}/.dotfiles/bash-helpers/path.sh"
    # source "${HOME}/.dotfiles/bash-helpers/bash.sh"

    source "${HOME}/.dotfiles/bash-helpers/ansible.sh"    # Ansible helpers
    source "${HOME}/.dotfiles/bash-helpers/docker.sh"     # Docker helpers
    source "${HOME}/.dotfiles/bash-helpers/go.sh"         # Golang helpers
    source "${HOME}/.dotfiles/bash-helpers/kubernetes.sh" # K8s helpers
    source "${HOME}/.dotfiles/bash-helpers/terraform.sh"  # Terraform helpers
    source "${HOME}/.dotfiles/bash-helpers/git.sh"        # git helpers
    source "${HOME}/.dotfiles/bash-helpers/aws.sh"        # aws helpers
    source "${HOME}/.dotfiles/bash-helpers/osx.sh"        # osx helpers
    source "${HOME}/.dotfiles/bash-helpers/python.sh"     # python helpers
    # source "/usr/local/etc/profile.d/z.sh"              # z cd auto completion
    source "${HOME}/.dotfiles/bash-helpers/ps1.sh" # set custom PS1
    source "${HOME}/.dotfiles/bash-helpers/ruby.sh"     # python helpers
}

# .bashrc
if [[ -f "${HOME}/.bashrc" ]]; then
	log debug "[$(basename "${BASH_SOURCE[0]}")]: Loading .bashrc..."

	# shellcheck source=/Users/ryanfisher/.bashrc
	source "${HOME}/.bashrc"
fi

log debug "[$(basename "${BASH_SOURCE[0]}")]: Done." ""
