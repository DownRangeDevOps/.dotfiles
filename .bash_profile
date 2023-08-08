# .bash_profile

# load .bashrc
if [[ -f ~/.bashrc ]]; then source ~/.bashrc; fi


. "/Users/ryanfisher/.rsvm/current/cargo/env"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
