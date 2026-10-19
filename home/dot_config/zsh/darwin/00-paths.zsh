# macOS paths. Runs BEFORE compinit (phase 1), so this is where the extra
# completion directories must be registered.

export BREW_PREFIX="${BREW_PREFIX:-$(/opt/homebrew/bin/brew --prefix 2>/dev/null || echo /opt/homebrew)}"

# Completion dirs (must precede compinit in ~/.zshrc)
[[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" $fpath)
[[ -d "$BREW_PREFIX/share/zsh-completions" ]] && fpath=("$BREW_PREFIX/share/zsh-completions" $fpath)

# Brew first, never a stale /usr/local shadowing it.
typeset -U path PATH
path=(
  $HOME/bin
  $HOME/.local/bin
  $BREW_PREFIX/bin
  $BREW_PREFIX/sbin
  $HOME/.cargo/bin
  $HOME/.yarn/bin
  /usr/local/bin
  /usr/local/sbin
  $path
)
export PATH

if (( $+commands[go] )); then
  export GOPATH=$HOME/code/go
  export GOBIN=$GOPATH/bin
  path=($GOBIN $path)
fi
