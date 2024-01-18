# shellcheck shell=bash

# Search history with arrows, up: \e[A, down: \e[B
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward

export ZPLUG_HOME="${HOMEBREW_PREFIX}/opt/zplug"

set +ua
# shellcheck disable=SC1091
if [[ -f "${HOMEBREW_PREFIX}/opt/antidote/share/antidote/antidote.zsh" ]]; then
    source "${HOMEBREW_PREFIX}/opt/antidote/share/antidote/antidote.zsh"
    antidote load "${HOME}/.dotfiles/config/.zsh_plugins.txt"
fi
set -ua

export ZVM_VI_ESCAPE_BINDKEY=jj

# The plugin will auto execute this zvm_after_select_vi_mode function
function zvm_after_select_vi_mode() {
    case "${ZVM_MODE}" in
        "${ZVM_MODE_NORMAL}")
            export ZVM_NORMAL_MODE_CURSOR="${ZVM_CURSOR_BLINKING_BLOCK}"
        ;;
        "${ZVM_MODE_INSERT}")
            export ZVM_INSERT_MODE_CURSOR="${ZVM_CURSOR_BLINKING_BEAM}"
        ;;
        "${ZVM_MODE_VISUAL}")
            export ZVM_VISUAL_MODE_CURSOR="${ZVM_CURSOR_BLINKING_UNDERLINE}"
        ;;
        "${ZVM_MODE_VISUAL_LINE}")
            export ZVM_VI_HIGHLIGHT_BACKGROUND=black,faint
        ;;
        "${ZVM_MODE_REPLACE}")
            export ZVM_VI_HIGHLIGHT_EXTRASTYLE=bold,underline
        ;;
    esac
}


