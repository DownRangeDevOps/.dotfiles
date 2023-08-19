# .bash_profile

# load .bashrc
if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile
fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform