# vim: ft=zsh
#
# Up/Down = search history by what you have already typed before the cursor.
#
# bear gets this from oh-my-zsh's lib/key-bindings.zsh, which autoloads zsh's
# own up-line-or-beginning-search / down-line-or-beginning-search widgets.
# Machines without oh-my-zsh (macOS) fall back to zsh's default
# up-line-or-history, which throws the typed prefix away.
#
# The widgets ship with zsh (Functions/Zle), so no plugin is required.
# zsh-history-substring-search is deliberately not bound: it matches anywhere
# in a history line, which is a different behaviour.

[[ -o interactive ]] || return 0

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -M emacs '^[[A' up-line-or-beginning-search
bindkey -M emacs '^[OA' up-line-or-beginning-search   # DECCKM / application cursor keys
bindkey -M emacs '^[[B' down-line-or-beginning-search
bindkey -M emacs '^[OB' down-line-or-beginning-search

zmodload zsh/terminfo 2>/dev/null
(( ${+terminfo[kcuu1]} )) && bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
(( ${+terminfo[kcud1]} )) && bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search

true
