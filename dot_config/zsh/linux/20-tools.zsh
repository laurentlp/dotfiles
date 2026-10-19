# nvm on Arch — the `nvm` package installs system-wide under /usr/share/nvm.
# Sourced after compinit (phase 2) because nvm registers completions.

export NVM_DIR="$HOME/.nvm"

for _f in /usr/share/nvm/init-nvm.sh /usr/share/nvm/nvm.sh; do
  [[ -r $_f ]] && { source $_f; break }
done
unset _f
