# Functions — the ones worth carrying over now that oh-my-zsh is gone.
#
# The old `tt()` ssh helper has been removed on purpose: it duplicated
# `Host tt` in ~/.ssh/config (same host, port 65476). Use `ssh tt`, which also
# picks up the keepalive settings.

# mkdir -p and cd into it (omz's `take`)
function take() {
  mkdir -p "$@" && cd "${@[-1]}"
}

function mkcd() {
  mkdir -p "$1" && cd "$1"
}
