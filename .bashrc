# vim: set ft=sh:
# .bashrc

# Source gcloud files first so PS1 gets overridden
# source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc # gcloud bash completion
# source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc       # gcloud binaries

# Configure path, must be first...
export PATH=""                                                          # Reset
source /etc/profile                                                     # Base
export PATH="${HOME}/go/bin:${PATH}"                                          # Go binaries
export PATH="/opt/X11/bin:${PATH}"
export PATH="${HOME}/.local/bin:${PATH}"                                      # pipx
export PATH="/usr/local/opt/ruby/bin:${PATH}"                           # Homebrew Ruby
for tool in 'gnu-tar' 'gnu-which' 'gnu-sed' 'grep' 'coreutils' 'make'; do
    export PATH="/usr/local/opt/${tool}/libexec/gnubin:${PATH}"         # Homebrew gnu tools
    export PATH="/usr/local/opt/${tool}/libexec/gnuman:${PATH}"         # Homebrew gnu manpages
done
export PATH="/usr/local/sbin:${PATH}"                                   # Homebrew bin path
export PATH="${HOME}/bin:${PATH}"                                       # Custom installed binaries

# Always append to ~/.bash_history
shopt -s histappend

# custom exports (e.g. paths, app configs)
export EDITOR=nvim
export HOMEBREW_GITHUB_API_TOKEN=811a3b56929faba4b429317da5752ff4d39afba6
export ECLIPSE_HOME=/Applications/Eclipse.app/Contents/Eclipse/
export GROOVY_HOME=/usr/local/opt/groovy/libexec
export BETTER_EXCEPTIONS=1  # python better exceptions
export AWS_ASSUME_ROLE_TTL=1h
export AWS_SESSION_TTL=12h

# Configure measurable docker-compose mount paths
export ANSIBLE_VAULT_PASSWORDS=${HOME}/.ansible/vault-passwords
export BITBUCKET_SSH_KEY=${HOME}/.ssh/id_rsa
export DEVOPS_REPO=${HOME}/dev/measurabl/src/devops

# Homebrew bash completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /usr/local/share/bash-completion/bash_completion ] && . /usr/local/share/bash-completion/bash_completion

# Configure FZF command
export FZF_DEFAULT_OPTS="--history=$HOME/.fzf_history"
export FZF_DEFAULT_COMMAND="/usr/local/bin/ag --hidden -g ''"

# Enable pyenv shims and pyenv-virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs  # python virtual env
export PROJECT_HOME=$HOME/dev
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
eval "$(pyenv init -)"
pyenv virtualenvwrapper_lazy

# Enable rbenv shims
eval "$(rbenv init -)"

# Enable `thefuck`
eval "$(thefuck --alias)"

# Use vi mode on command line
# set -o vi
# bind '"jj":vi-movement-mode'

# Enable an iTerm2 clock badge
# function iterm2_print_user_vars() {
#   iterm2_set_user_var currTime $(date +%R)
# }
# ((while [ 1 ] ; do iterm2_print_user_vars; sleep 5; done) &) &> /dev/null

# Add git completion to aliases
function_exists() {
  declare -f -F "${1}" > /dev/null
  return $?
}

# for git_alias in $(__git_aliases); do
#   complete_alias=_git_$(__git_aliased_command $git_alias)
#   function_exists $complete_alias && __git_complete $complete_alias
# done

# Don't expand paths
_expand() { return 0; }

# Use hub as git
alias git=hub
alias g=hub

# Ansible vault shortcuts
alias aav='ansible-vault view'
function ade() {
    if [[ -z $1 ]]; then
        printf "%s\n" "Usage:"
        printf "%s\n" "    ade <environment>"
        return 1
    fi
  find "environments/${1}/" \
    -type f \
    -iname '*.vault.*' \
    -exec sh -c "ansible-vault decrypt \
      --vault-id ${HOME}/.ansible/vault-passwords/${1} {}" \
      \;
}

function aes() {
    if [[ -z $1 || -z $2 ]]; then
        printf "%s\n" "Usage:"
        printf "%s\n" "    aes <environment> <variable name>"
        return 1
    fi
    read -p "String to encrypt: " -sr
    ansible-vault encrypt_string --vault-id "~/.ansible/vault-passwords/${1}" -n "${2}" "${REPLY}" \
        | sed 's/^  */  /' \
        | tee /dev/tty \
        | pbcopy
    printf "%s\n" "The result has been copied to your clipboard."
}

function ads() {
    if [[ -z $1 || -z $2 || -z $3 ]]; then
        printf "%s\n" "Usage:"
        printf "%s\n" "    ads <environment> <yaml_file> <variable_path>"
        return 1
    fi
    yq -t read "${2}" "${3}" \
    | ansible-vault decrypt --vault-password-file "~/.ansible/vault-passwords/${1}" \
    | tee /dev/tty \
    | pbcopy
    printf "%s\n" "The result has been copied to your clipboard."
}

# My helpers
alias genpasswd="openssl rand -base64 32"
alias myip="curl icanhazip.com"
vagrant_up() {
  if [[ $1 && $1 == '-p' || $1 == '--provision' ]]; then vagrant up --provision; elif [[ $1 && $1 != '-p' ]]; then echo 'Unknown argument...'; else vagrant up; fi
}
alias vu="vagrant_up"
alias vh="vagrant halt"
alias vs="vagrant ssh"
alias sb="source ${HOME}/.bashrc"
alias ebash="nvim ${HOME}/.bashrc"
alias c="clear"
alias vim="nvim"
function nvim() {
    if [[ ! "${VIRTUAL_ENV}" =~ /nvim$ ]]; then
        workon nvim
    fi

    /usr/bin/env nvim
}

# Auto on Yubiswitch
alias ssh="osascript -e 'tell application \"yubiswitch\" to KeyOn' && ssh"
alias scp="osascript -e 'tell application \"yubiswitch\" to KeyOn' && scp"

### Helper funcitons

# Prompt user to continue
prompt_to_continue() {
    echo ''
    read -p "${1:-Continue?} (y)[es|no] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    fi

    return 1
}

# Join array
function join() {
    local IFS=$1
    __="${*:2}"
}

# Disable flow control commands (keeps C-s from freezing everything)
stty start undef
stty stop undef


history -a
history -n

# color output for `ls`
export LS_COLORS='rs=0:di=1;35:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'

# Safety
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
set -o noclobber

# tmux & tmuxinator
alias tmux='tmux -2'                # Force 256 colors in tmux
alias tks='tmux kill-session -t '   # easy kill tmux session
alias rc='reattach-to-user-namespace pbcopy'

# Generate password hash for MySQL
alias mysqlpw="/usr/bin/python -c 'from hashlib import sha1; import getpass; print \"*\" + sha1(sha1(getpass.getpass(\"New MySQL Password:\")).digest()).hexdigest()'"

# Listing, directories and motion
function ls() {
  /bin/ls -GhA "$@"
}
function ll() {
  /bin/ls -GFlash "$@"
}
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ..r='cd $(git rev-parse --show-toplevel 2>/dev/null)'
alias ..~='cd ${HOME}'

# grep options
alias grep="grep --color"
export GREP_COLOR="$(tput setaf 2 && tput setab 29 | tr -d m)" # green for matches
alias ag='ag --hidden --ignore tags --ignore .git --color --color-match="$(tput setaf 2 && tput setab 29 | tr -d m)"'

# helpers
source ~/.dotfiles/.dockerconfig            # Docker helpers
source ~/.dotfiles/.terraform               # Terraform helpers
source ~/.dotfiles/.git_helpers 2>/dev/null # git helpers
source ~/.dotfiles/.awsconfig               # aws helpers
source ~/.dotfiles/.osx                     # osx helpers
source /usr/local/etc/profile.d/z.sh        # z cd auto completion
source ~/.dotfiles/.ps1                     # Custom PS1

# Add the direnv hook to PROMPT_COMMAND
# source ~/.direnvrc
eval "$(direnv hook bash)"

complete -C /usr/local/bin/terraform terraform
