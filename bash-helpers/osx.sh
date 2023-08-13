# vim: set ft=sh:
# osx.sh
logger "" "[${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  aliases
# ------------------------------------------------
logger "[$(basename "${BASH_SOURCE[0]}")]: Loading alises..."

alias flushdns='sudo killall -HUP mDNSResponder'
alias showfiles='defaults write com.apple.finder AppleShowAllFiles true; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles false; killall Finder'

# Fix screen flash when audio process dies
alias fixflash='sudo killall coreaudiod'
