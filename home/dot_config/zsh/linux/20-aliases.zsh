# GNU ls colouring. BSD/macOS ls has no --color (it uses CLICOLOR, see the
# darwin fragment), so this alias lives here rather than in common/.
#
# `ll`/`la`/`l` are plain `ls …` aliases, and zsh re-expands the leading word,
# so they pick this up too: `ll` becomes `ls --color=auto --group-directories-first -lh`.
alias ls='ls --color=auto --group-directories-first'
