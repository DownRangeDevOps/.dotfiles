# .bash_profile

# load .bashrc
if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile
fi

autoload -U +X bashcompinit && bashcompinit
complete -C "${HOMEBREW_PREFIX}/bin/terraform" terraform

# added by Snowflake SnowSQL installer v1.2
export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/xjxf277/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
