# vim: set ft=sh:
# .bashrc

# Log xtrace for this script and timestamp it to find slow loading dependencies
# exec 5> >(ts -i "%.s" >> /tmp/bash_debug.log)
# PS4='$LINENO: '
# export BASH_XTRACEFD="5"
# set -xv

# Source gcloud files first so PS1 gets overridden
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc" # gcloud bash completion
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"       # gcloud binaries

# Configure path, must be first...
export PATH=""                                                # Reset
source /etc/profile                                           # Base
export PATH="/opt/X11/bin:${PATH}"
export PATH="/usr/local/opt/ruby/bin:${PATH}"                   # Homebrew Ruby
for tool in 'gnu-tar' 'gnu-which' 'gnu-sed' 'grep' 'coreutils' 'make'; do
    export PATH="/usr/local/opt/${tool}/libexec/gnubin:${PATH}" # Homebrew gnu tools
    export PATH="/usr/local/opt/${tool}/libexec/gnuman:${PATH}" # Homebrew gnu manpages
done
export PATH="/usr/local/sbin:${PATH}"                           # Homebrew bin path
export PATH="$HOME/.pyenv/bin:$PATH"                            # pyenv
export PATH="$HOME/.local/bin:${PATH}"                        # pipx
export PATH="$HOME/go/bin:${PATH}"                            # Go binaries
export PATH="${PATH}:$HOME/.snowsql/1.2.12"                   # Snowflake CLI
export PATH="$HOME/bin:${PATH}"                               # Custom installed binaries
export PATH="${PATH}:$HOME/.local/bin"                        # Ansible:::
export PATH="${PATH}:$HOME/.cabal/bin/git-repair"             # Haskell binaries

# Always append to ~/.bash_history
shopt -s histappend

# custom exports (e.g. paths, app configs)
export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"
export EDITOR=nvim
export HOMEBREW_GITHUB_API_TOKEN=811a3b56929faba4b429317da5752ff4d39afba6
export ECLIPSE_HOME=/Applications/Eclipse.app/Contents/Eclipse/
export GROOVY_HOME=/usr/local/opt/groovy/libexec
export BETTER_EXCEPTIONS=1  # python better exceptions
export AWS_ASSUME_ROLE_TTL=1h
export AWS_SESSION_TTL=12h
export PTPYTHON_CONFIG_HOME="$HOME/.config/ptpython/"
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'  # avoid accidentally linking against a Pyenv-provided Python (see: https://github.com/pyenv/pyenv#installation)

# Configure measurable docker-compose mount paths
export ANSIBLE_VAULT_PASSWORDS="$HOME/.ansible/vault-passwords"
export BITBUCKET_SSH_KEY="$HOME/.ssh/id_rsa"
export DEVOPS_REPO="$HOME/dev/measurabl/src/devops"

# Configure aws-vault
export AWS_VAULT_BACKEND=file

# Homebrew bash completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Configure FZF command
export FZF_DEFAULT_OPTS="--history=$HOME/.fzf_history"
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Pyenv (https://github.com/pyenv/pyenv)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"  # pyenv-virtualenv is a venv mgmt tool for pyenv (see: https://github.com/pyenv/pyenv-virtualenv)

# Pyenv-virtualenvwrapper (https://github.com/pyenv/pyenv-virtualenvwrapper)
export WORKON_HOME="$HOME/.virtualenvs"
export PROJECT_HOME="$HOME/dev"
export VIRTUALENVWRAPPER_WORKON_CD=1
pyenv virtualenvwrapper

# Pipx
export PIPX_DEFAULT_PYTHON="${HOME}/.pyenv/shims/python"

## Load package shims
eval "$(pyenv init --path)"       # Enable pyenv shims
eval "$(pyenv virtualenv-init -)" # Enable pyenv virtualenv shims
eval "$(goenv init -)"            # Setup shell to make go binary available
eval "$(rbenv init -)"            # Enable rbenv shims
# TOO SLOW # eval "$(thefuck --alias)"       # Enable `thefuck`

# Use vi mode on command line
set -o vi
bind '"jj":vi-movement-mode'

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
    -exec sh -c 'passfile="$1"; \
        ansible-vault decrypt \
        --vault-id $passfile' shell "$HOME/.ansible/vault-passwords/${1}" {} \
      \;
}

function aes() {
    if [[ -z $1 || -z $2 ]]; then
        printf "%s\n" "Usage:"
        printf "%s\n" "    aes <environment> <variable name>"
        return 1
    fi
    read -p "String to encrypt: " -sr
    ansible-vault encrypt_string --vault-id "$HOME/.ansible/vault-passwords/${1}" -n "${2}" "${REPLY}" \
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
    | ansible-vault decrypt --vault-password-file "$HOME/.ansible/vault-passwords/${1}" \
    | tee /dev/tty \
    | pbcopy
    printf "%s\n" "The result has been copied to your clipboard."
}

# My helpers
alias rml=run_mega_linter_python
alias genpasswd="openssl rand -base64 32"
alias myip="curl icanhazip.com"
alias vu="vagrant_up"
alias vh="vagrant halt"
alias vs="vagrant ssh"
alias sb='source $HOME/.bashrc'
alias ebash='nvim $HOME/.bashrc'
alias c="clear"
alias vim="nvim"

function run_mega_linter_python() {
    if [[ $(prompt_to_continue "Remove the existing report directory?") -eq 0 ]]; then
        rm -rf report
    fi

    mega-linter-runner -f python "${@}" .
}

# Headers and colors
function header() {
    printf "\n%b\n" "\x1b[1m==> ${*}\x1b[0m"
}

function reset() {
    "\x1b[0m"
}

function green() {
    "\x1b[32;01m${*}\x1b[0m"
}

function yellow() {
    "\x1b[33;01m${*}\x1b[0m"
}

function red() {
    "\x1b[33;31m${*}\x1b[0m"
}

function indent_output() {
    sed "s/^/    /"
}


# Utilities
function nvim() {
    if [[ ! "${VIRTUAL_ENV}" =~ /nvim$ ]]; then
        workon nvim
    fi

    /usr/bin/env nvim "$@"
}

function vagrant_up() {
  if [[ $1 && $1 == '-p' || $1 == '--provision' ]]; then vagrant up --provision; elif [[ $1 && $1 != '-p' ]]; then echo 'Unknown argument...'; else vagrant up; fi
}

function lpy() {
    SQLFLUFF=("--processes=$(($(sysctl -n hw.ncpu) - 2))" "--FIX-EVEN-UNPARSABLE" "--force")
    SQL_FORMATTER=("--language=postgresql" "--uppercase" "--lines-between-queries=1" "--indent=4")
    FLYNT=("--transform-concats" "--line-length=999")
    AUTOPEP8=("--in-place" "--max-line-length=88" "--recursive")
    AUTOFLAKE=("--remove-all-unused-imports" "--remove-duplicate-keys" "--in-place" "--recursive")
    PRETTIER=("--ignore-path=$HOME/.config/prettier" "--write" "--print-width=88")
    MDFORMAT=("--number" "--wrap=80")
    ISORT=("--profile=black" "--skip-gitignore" "--trailing-comma" "--wrap-length=88" "--line-length=88" "--use-parentheses" "--ensure-newline-before-comments")
    BLACK=("--preview")

    ALL_FILES=($(rg --files --color=never))
    SQL_FILES=($(rg --files --color=never --glob '*.sql'))

    header "Removing trailing whitespace..."
    printf "${ALL_FILES[@]}" | xargs -L 1 sed -E -i 's/\s*$//g' | indent_output

    header "Running sql-formatter fix with '${SQL_FORMATTER[*]}'..."
    printf "${SQL_FILES[@]}" | xargs -I {} -L 1 \
            sql-formatter "${SQL_FORMATTER[@]}" --output={} {} | indent_output

    header "Running sqlfluff fix with '${SQLFLUFF[*]}'..."
    [[ -n ${SQL_FILES} ]] && sqlfluff fix "${SQLFLUFF[@]}" . | indent_output

    header "Running flynt with '${FLYNT[*]}'..."
    flynt "${FLYNT[@]}" . | indent_output

    header "Running autopep8 with '${AUTOPEP8[*]}'..."
    autopep8 "${AUTOPEP8[@]}" . | indent_output

    header "Running autoflake with '${AUTOFLAKE[*]}'..."
    autoflake "${AUTOFLAKE[@]}" . | indent_output

    header "Running prettier with '${PRETTIER[*]}'..."
    prettier "${PRETTIER[@]}" . | indent_output

    header "Running mdformat with '${MDFORMAT[*]}'..."
    mdformat "${MDFORMAT[@]}" . | indent_output

    header "Running isort with '${ISORT[*]}'..."
    isort "${ISORT[@]}" . | indent_output

    header "Running black with '${BLACK[*]}'..."
    black "${BLACK[@]}" . | indent_output
}

# Auto on Yubiswitch
alias ssh="osascript -e 'tell application \"yubiswitch\" to KeyOn' && ssh"
alias scp="osascript -e 'tell application \"yubiswitch\" to KeyOn' && scp"

### Helper funcitons

# Prompt user to continue
function prompt_to_continue() {
    read -p "${*:-Continue?} (y)[es|no] " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        printf "%s\n" "Ok, exiting."
        exit 1
    fi

    printf "\n"
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
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ..r="cd \$(git rev-parse --show-toplevel 2>/dev/null)"
alias ..~="cd \$HOME"
alias cdp="cd \$(pwd | sed -e \"s|\(.*/projects\)/[^/]*/\(.*\)$|\1/production/\2/|\")"
alias cds="cd \$(pwd | sed -e \"s|\(.*/projects\)/[^/]*/\(.*\)$|\1/staging/\2/|\")"
alias cdd="cd \$(pwd | sed -e \"s|\(.*/projects\)/[^/]*/\(.*\)$|\1/demo/\2/|\")"
alias cdt="cd \$HOME/dev/sightly/src/ops/packages/terraform/projects/"
alias cdv="cd \$HOME/dev/sightly/src/ops/vendors/"

# grep options
alias grep="grep --color"
GREP_COLOR="$(tput setaf 2 && tput setab 29 | tr -d m)" # green for matches
export GREP_COLOR
alias ag='ag \
    --hidden \
    --ignore tags \
    --ignore .git \
    --ignore .terraform \
    --color --color-match="$(tput setaf 2 && tput setab 29 | tr -d m)"'

# helpers
source "$HOME/.dotfiles/.dockerconfig"            # Docker helpers
source "$HOME/.dotfiles/.terraform"               # Terraform helpers
source "$HOME/.dotfiles/.git_helpers" 2>/dev/null # git helpers
source "$HOME/.dotfiles/.awsconfig"               # aws helpers
source "$HOME/.dotfiles/.osx"                     # osx helpers
source "/usr/local/etc/profile.d/z.sh"            # z cd auto completion
source "$HOME/.dotfiles/.ps1"                     # Custom PS1

alias pipelinewise="\$HOME/dev/sightly/src/ops/vendors/pipelinewise/bin/pipelinewise-docker"
alias csqldev="cloud_sql_proxy -instances=sightly-outcome-development:us-west1:sightly-development-outcome-postgres=tcp:0.0.0.0:8765"
alias csqlstg="cloud_sql_proxy -instances=sightlyoutcomeintellplatform:us-west2:sightly-staging-postgres-u16w=tcp:0.0.0.0:7654 &"
alias csqlprd="cloud_sql_proxy -instances=sightlyoutcomeintellplatform:us-west2:sightly-production-postgres-7ish=tcp:0.0.0.0:6543 &"
alias snowp="snowsql -a sightly -u ryanfisher -d CONTENT_INTELLIGENCE_PROD -r SIGHTLY_ENGINEERING -w SIGHTLY_ENGINEERING_WEB_WH -h sightly.us-central1.gcp.snowflakecomputing.com"
alias snows="snowsql -a sightly -u ryanfisher -d CONTENT_INTELLIGENCE_STAGING -r SIGHTLY_ENGINEERING -w SIGHTLY_ENGINEERING_WEB_WH -h sightly.us-central1.gcp.snowflakecomputing.com"
alias snowas="snowsql -a sightly -u ryanfisher -d AYLIEN_STAGING -r SIGHTLY_ENGINEERING -w SIGHTLY_ENGINEERING_WEB_WH -h sightly.us-central1.gcp.snowflakecomputing.com"
alias ctags="\$(brew --prefix)/bin/ctags"
alias gpt=generate_python_module_ctags

function get_python_module_paths() {
    python -c "import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))"
}

function generate_python_module_ctags() {
    read -r -a PYTHON_PATH  <<< "$(get_python_module_paths)"

    rm -f ./tags
    ctags -R \
        --fields=+l \
        --python-kinds=-i \
        --exclude='*.pxd' \
        --exclude='*.pxy' \
        -f ./tags . "${PYTHON_PATH[@]}"
}

# Add the direnv hook to PROMPT_COMMAND
# source ~/.direnvrc
eval "$(direnv hook bash)"

complete -C /usr/local/bin/terraform terraform
source "$HOME/.rsvm/current/cargo/env"
