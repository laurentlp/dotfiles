# zsh plugins on Arch — the packages install under /usr/share/zsh/plugins/.
# Both spellings are probed; whichever exists wins.

for _f in /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
          /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh; do
  [[ -r $_f ]] && { source $_f; break }
done
unset _f

# zsh-syntax-highlighting MUST be sourced last of everything.
for _f in /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
          /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
  [[ -r $_f ]] && { source $_f; break }
done
unset _f
