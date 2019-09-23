# .bash_profile

# load .bashrc
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
