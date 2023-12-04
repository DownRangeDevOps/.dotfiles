# .bash_profile

# load .bashrc
if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile
fi

autoload -U +X bashcompinit && bashcompinit
complete -C "${HOMEBREW_PREFIX}/bin/terraform" terraform

# added by Snowflake SnowSQL installer v1.2
export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH
