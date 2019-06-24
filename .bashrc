# # vim: set ft=sh:
# .bashrc

# Always append to ~/.bash_history
shopt -s histappend

# custom exports (e.g. paths, app configs)
export EDITOR=nvim
export HOMEBREW_GITHUB_API_TOKEN=811a3b56929faba4b429317da5752ff4d39afba6
export ECLIPSE_HOME=/Applications/Eclipse.app/Contents/Eclipse/
export GROOVY_HOME=/usr/local/opt/groovy/libexec
export BETTER_EXCEPTIONS=1  # python better exceptions

# Configure measurable docker-compose mount paths
export ANSIBLE_VAULT_PASSWORDS=${HOME}/.ansible/vault-passwords
export BITBUCKET_SSH_KEY=${HOME}/.ssh/id_rsa
export DEVOPS_REPO=${HOME}/dev/measurabl/src/devops

# Homebrew bash completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /usr/local/share/bash-completion/bash_completion ] && . /usr/local/share/bash-completion/bash_completion

# Use custom binaries and those installed by Homebrew over OSX defaults
source /etc/profile                # Set base path
export PATH="${HOME}/bin:${PATH}"  # Custom installed binaries

# Configure FZF command
export FZF_DEFAULT_COMMAND="/usr/local/bin/ag --hidden --ignore tags --ignore .git -g ''"

# Configure virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs  # python virtual env
export PROJECT_HOME=$HOME/dev
export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh

# Enable pyenv shims and pyenv-virtualenvwrapper
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
eval "$(pyenv init -)"
pyenv virtualenvwrapper_lazy

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
  declare -f -F $1 > /dev/null
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
  find "environments/${1}/" \
    -type f \
    -iname '*.vault.*' \
    -exec sh -c "ansible-vault decrypt \
      --vault-password-file ~/.ansible/vault-passwords/${1} {}" \
      \;
}

# My helpers
alias myip="curl icanhazip.com"
vagrant_up() {
  if [[ $1 && $1 == '-p' || $1 == '--provision' ]]; then vagrant up --provision; elif [[ $1 && $1 != '-p' ]]; then echo 'Unknown argument...'; else vagrant up; fi
}
alias vu="vagrant_up"
alias vh="vagrant halt"
alias vs="vagrant ssh"
alias sb="source ~/.bashrc"
alias ebash="vim ~/.bashrc"
alias c="clear"

# If -r/--git-version is not supplied, mount the current directory and run migrations
function msr-migrate() {
    if [[ " ${@} " =~ " -r " || " ${@} " =~ " --git-version " ]]; then
        docker run msr-migrate ${@}
    else
        docker run -v ${PWD}:/src msr-migrate ${@}
    fi
}

# Auto on Yubiswitch
alias ssh="osascript -e 'tell application \"yubiswitch\" to KeyOn' && ssh"
alias scp="osascript -e 'tell application \"yubiswitch\" to KeyOn' && scp"

# Easy edit custom dot files with menu prompt
edot() {
  if [[ $# -gt 0 ]]; then
    vim "~/${$@}"
  else
    shopt -s dotglob
    options=$(find ~/.dotfiles -maxdepth 1 -type f -name ".[^.]*" -printf "%f\n" | sed -e 's/^\.//g' | sort --ignore-case)
    COLUMNS=80
    select FILE in $options;
    do
      vim ~/.dotfiles/.$FILE
      break
    done
    shopt -u dotglob
  fi
}

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

# Sexy Bash Prompt, inspired by "Extravagant Zsh Prompt"
# if [[ $COLORTERM = gnome-* && $TERM = xterm ]]  && infocmp gnome-256color >/dev/null 2>&1; then export TERM=gnome-256color
# elif [[ $TERM != dumb ]] && infocmp xterm-256color >/dev/null 2>&1; then export TERM=xterm-256color
# fi

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BOLD=$(tput bold)
RESET=$(tput sgr0)

function parse_git_branch () {
    git_branch | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

function parse_git_dirty () {
    case $(git status 2>/dev/null) in
        *"Changes not staged for commit"*)
            echo " ${RED}✗";;
        *"Changes to be committed"*)
            echo " ${YELLOW}✗";;
        *"nothing to commit"*)
            echo "";;
    esac
}

function get_virtualenv () {
    if [[ $VIRTUAL_ENV ]]; then
        echo " ($(basename $VIRTUAL_ENV))"
    else
        echo ""
    fi
}

function git_project_parent() {
    echo -n "$(git rev-parse --show-toplevel 2>/dev/null)/.."
}

function git_project_root () {
    if [[ -n $(git branch 2>/dev/null) ]]; then
        echo "git@$(realpath --relative-to=$(git_project_parent) .)"
    else
        echo ${PWD/~/\~}
    fi
}

function git_branch () {
    git branch --no-color 2>/dev/null
}

function get_shell_lvl () {
    LEVEL=1
    [[ -n NVIM_LISTEN_ADDRESS ]] && LEVEL=2
    [[ $SHLVL > $LEVEL ]] && echo "($SHLVL)"
}

function get_aws_vault () {
    [[ -n $AWS_VAULT ]] && echo "($AWS_VAULT)"
}

function __ps1_prompt () {
    PS1="$(get_shell_lvl)$(get_aws_vault)$(get_virtualenv) \[${CYAN}\]→ \[${RESET}\]"
    echo -e "\
$(date +%R) \
${YELLOW}$(git_project_root)${RESET}\
$([[ -n $(git_branch) ]] && echo " on ")\
${MAGENTA}$(parse_git_branch)${RESET}"
}

history -a
history -n
PROMPT_COMMAND='history -a ~/.bash_history; history -n ~/.bash_history; __ps1_prompt; ${PROMPT_COMMAND:-:}'

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
alias ...='cd ..;cd ..'
alias ....='cd ..;cd ..;cd ..'
alias .....='cd ..;cd ..;cd ..;cd ..'
alias ..r='cd $(git rev-parse --show-toplevel 2>/dev/null)'
alias ..~='cd ~'

# grep options
alias grep='ag'
alias ag="ag --hidden --ignore tags --ignore .git --color --color-match='$(tput setaf 2 && tput setab 29 | tr -d m)'"
export GREP_COLOR="$(tput setaf 2 && tput setab 29)" # green for matches

# helpers
source ~/.dotfiles/.dockerconfig                # Docker helpers
source ~/.dotfiles/.git_helpers 2>/dev/null     # git helpers
source ~/.dotfiles/.awsconfig                   # aws helpers
source ~/.dotfiles/.osx                         # osx helpers
source /usr/local/etc/profile.d/z.sh            # z cd autocompleation
