# nvm on Arch — the `nvm` package installs system-wide under /usr/share/nvm,
# and its init script sets NVM_DIR itself. Sourced after compinit (phase 2)
# because nvm registers completions.
#
# NVM_DIR is only pre-set for the bare nvm.sh fallback: forcing $HOME/.nvm before
# sourcing init-nvm.sh can point the package's script at the wrong version dir.

if [[ -r /usr/share/nvm/init-nvm.sh ]]; then
  source /usr/share/nvm/init-nvm.sh
elif [[ -r /usr/share/nvm/nvm.sh ]]; then
  export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
  source /usr/share/nvm/nvm.sh
fi
