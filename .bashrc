# vim: set ft=sh:
# .bashrc
source ~/.dotfiles/.dockerconfig                # Docker helpers
source ~/.dotfiles/.git_helpers                 # git helpers
source ~/.dotfiles/.awsconfig                   # aws helpers
source ~/.dotfiles/.osx                         # osx helpers
source /usr/local/etc/profile.d/z.sh            # z cd autocompleation
[[ ! $VIRTUAL_ENV ]] && source /usr/local/bin/virtualenvwrapper.sh      # setup virtualenvwrapper hooks

# custom exports (e.g. paths, app configs)
#export GOPATH=$HOME/dev/go
#export BINPATH=$HOME/bin
#export PATH=${PATH}:$GOPATH/bin:$BINPATH
export EDITOR=nvim
export HOMEBREW_GITHUB_API_TOKEN=811a3b56929faba4b429317da5752ff4d39afba6
export ECLIPSE_HOME=/Applications/Eclipse.app/Contents/Eclipse/
export WORKON_HOME=$HOME/.virtualenvs   # python virtual env
export PROJECT_HOME=$HOME/dev/python_virtualenv_projects

# Homebrew bash completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /usr/local/share/bash-completion/bash_completion ] && . /usr/local/share/bash-completion/bash_completion

# Use custom binaries and those installed by Homebrew over OSX defaults
source /etc/profile                                                 # Set base path
export PATH="/usr/locexec/bin:${PATH}"                              # Homebrew
export PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"       # Homebrew coreutils
export PATH="/usr/local/opt/python/libexec/bin:$PATH"               # Homebrew python
export PATH="/usr/local/lib/python2.7/site-packages:${PATH}"        # Homebrew pip2 packages
export PATH="/usr/local/lib/python3.6/site-packages:${PATH}"        # Homebrew pip3 packages
export PATH="/Users/ryanfisher/.gem/ruby/2.4.0:${PATH}"             # Ruby gems isntalled with --user
export PATH="/usr/local/lib/ruby/gems/2.4.0:${PATH}"                # Ruby gems installed for the system
export PATH="~/bin:${PATH}"                                         # Custom installed binaries
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"   # Hoembrew coreutils manpages
#export PATH=${PATH}:/usr/local/mysql/bin

# Enable `thefuck`
eval "$(thefuck --alias)"

# Use vi mode on command line
set -o vi
bind '"jj":vi-movement-mode'

# Add git completion to aliases
function_exists() {
  declare -f -F $1 > /dev/null
  return $?
}

for git_alias in $(__git_aliases); do
  complete_alias=_git_$(__git_aliased_command $git_alias)
  function_exists $complete_alias && __git_complete $complete_alias
done

# Don't expand paths
_expand() { return 0; }

# Use hub as git
alias git=hub
alias g=hub

# Ansible vault shortcuts
alias aav='ansible-vault view'

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

# Generic function to add a confirmation prompt
confirm() {
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

# Disable flow control commands (keeps C-s from freezing everything)
stty start undef
stty stop undef

# Sexy Bash Prompt, inspired by "Extravagant Zsh Prompt"
# if [[ $COLORTERM = gnome-* && $TERM = xterm ]]  && infocmp gnome-256color >/dev/null 2>&1; then export TERM=gnome-256color
# elif [[ $TERM != dumb ]] && infocmp xterm-256color >/dev/null 2>&1; then export TERM=xterm-256color
# fi

if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
      MAGENTA=$(tput setaf 9)
      ORANGE=$(tput setaf 172)
      GREEN=$(tput setaf 190)
      PURPLE=$(tput setaf 141)
      WHITE=$(tput setaf 12)  # changed from 256 to 12 for solarized fg color
    else
      MAGENTA=$(tput setaf 5)
      ORANGE=$(tput setaf 4)
      GREEN=$(tput setaf 2)
      PURPLE=$(tput setaf 1)
      WHITE=$(tput setaf 12)
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    MAGENTA="\033[1;31m"
    ORANGE="\033[1;33m"
    GREEN="\033[1;32m"
    PURPLE="\033[1;35m"
    WHITE="\033[1;37m"
    BOLD=""
    RESET="\033[m"
fi

function parse_git_dirty () {
    case $(git status 2> /dev/null) in
        *"Changes not staged for commit"*)
            echo " ${MAGENTA}✗";;
        *"Changes to be committed"*)
            echo " ${GREEN}✗";;
        *"nothing to commit"*)
            echo "";;
    esac
}

function parse_git_branch () {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

function get_virtualenv () {
    if [[ $VIRTUAL_ENV ]]; then
        echo " ($(basename $VIRTUAL_ENV))"
    else
        echo ""
    fi
}

function show_vi_mode () {
    PS1='$(get_virtualenv) → '
    echo -e "$(date +%R) ${MAGENTA}$(whoami)${RESET} at ${ORANGE}$(hostname -s)${RESET} in ${GREEN}${PWD}${RESET}$([[ -n $(git branch 2>/dev/null) ]] && echo " on ")${PURPLE}$(parse_git_branch)${RESET}"
}

PROMPT_COMMAND='show_vi_mode'

# color output for `ls`
export LS_COLORS='no=00:fi=00:di=01;35:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.flac=01;35:*.mp3=01;35:*.mpc=01;35:*.ogg=01;35:*.wav=01;35:'

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

# grep options
alias grep='grep --color=auto '
export GREP_COLOR='1;31' # green for matches
