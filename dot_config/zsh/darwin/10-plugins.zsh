# zsh plugins on macOS — Homebrew installs them under $BREW_PREFIX/share/<name>.
# Both /opt/homebrew (arm64) and /usr/local (Intel) are probed so this file
# survives a machine swap.

for _f in "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
          "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh"; do
  [[ -r $_f ]] && { source $_f; break }
done
unset _f

# zsh-syntax-highlighting MUST be sourced last of everything (it wraps zle
# widgets defined by everything before it).
for _f in "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
          "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"; do
  [[ -r $_f ]] && { source $_f; break }
done
unset _f
