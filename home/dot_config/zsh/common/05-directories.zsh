# Directory handling — ported from oh-my-zsh lib/directories.zsh, which we no
# longer load. These are the pieces that are actually used day to day.

setopt auto_cd              # `foo` on a directory name cds into it
setopt auto_pushd           # cd keeps a stack
setopt pushd_ignore_dups    # ...without duplicate entries
setopt pushdminus

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias d='dirs -v | head -10'
