# Prompt — starship on every machine (replaces oh-my-zsh + powerlevel10k).
#
# Both machines run starship with its defaults, so the prompt is identical by
# construction. To customise: `starship preset <name> -o ~/.config/starship.toml`
# then `chezmoi add ~/.config/starship.toml`.

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi
