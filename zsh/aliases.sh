if [[ "$OSTYPE" == darwin* ]]; then
  alias o='open'
else
  alias o='xdg-open'

  if [ $+commands[xclip] ]; then
    alias pbcopy='xclip -selection clipboard -in'
    alias pbpaste='xclip -selection clipboard -out'
  fi
fi

alias pbc='pbcopy'
alias pbp='pbpaste'

if [ $+commands[curl] ]; then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
elif [ $+commands[wget] ]; then
  alias get='wget --continue --progress=bar --timestamping'
fi

if [ $+commands[python3] ]; then
  alias http-serve='python3 -m http.server'
else
  alias http-serve='python -m SimpleHTTPServer'
fi

alias grep='grep --color=auto'

alias vi='nvim'
alias pacman='sudo pacman'