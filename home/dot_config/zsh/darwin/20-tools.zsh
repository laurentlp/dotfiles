# nvm on macOS — Homebrew keeps it under $BREW_PREFIX/opt/nvm.
# Sourced after compinit (phase 2) because nvm registers completions.

export NVM_DIR="$HOME/.nvm"

for _f in "$BREW_PREFIX/opt/nvm/nvm.sh" "/usr/local/opt/nvm/nvm.sh"; do
  [[ -r $_f ]] && { source $_f; break }
done
unset _f
