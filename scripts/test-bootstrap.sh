#!/bin/sh
# Smoke-test bootstrap.sh on a clean Arch container.
#
#   scripts/test-bootstrap.sh
#
# This is the only way to verify the "one command on a fresh machine" claim
# without a spare box: a real archlinux image with no shell config and no
# chezmoi. It mounts the repo read-only, copies it to /root, runs bootstrap.sh,
# and asserts the result.
set -eu

repo=$(cd "$(dirname "$0")/.." && pwd)
image=${IMAGE:-archlinux:latest}

command -v docker >/dev/null 2>&1 || {
  echo "docker not found — install it or run this on a machine that has it." >&2
  exit 1
}

echo "==> running in $image (repo mounted at /src)" >&2

docker run --rm -v "$repo:/src:ro" "$image" bash -eu -c '
  # fresh Arch images ship a stale keyring; refresh it before anything else
  pacman -Sy --noconfirm --needed archlinux-keyring >/dev/null
  pacman -S --noconfirm --needed git gzip >/dev/null

  cp -a /src /root/dotfiles
  cd /root/dotfiles

  echo "==> bootstrap.sh"
  ./bootstrap.sh

  echo
  echo "==> assertions"

  fail=0
  # Note: the command is a *string* evaluated later, so single-quote it.
  # Double quotes would expand $f etc. in this shell under set -u.
  check() {
    if eval "$2" >/dev/null 2>&1; then
      printf "  ok    %s\n" "$1"
    else
      printf "  FAIL  %s\n" "$1"
      fail=1
    fi
  }

  check "zsh installed"                "command -v zsh"
  check "starship installed"           "command -v starship"
  check "~/.zshrc is a regular file"   "test -f /root/.zshrc && test ! -L /root/.zshrc"
  check "~/.zshrc parses"              "zsh -n /root/.zshrc"
  check "every common fragment parses" "for f in /root/.config/zsh/common/*.zsh; do zsh -n \"\$f\" || exit 1; done"
  check "linux fragments present"      "test -f /root/.config/zsh/linux/00-paths.zsh"
  check "darwin fragments absent"      "test ! -e /root/.config/zsh/darwin"
  check "ssh config is mode 0600"      "[ \"\$(stat -c %a /root/.ssh/config)\" = 600 ]"
  check "gitconfig rendered"           "grep -q \"@\" /root/.gitconfig"
  check "chezmoi status is empty"      "[ -z \"\$(chezmoi status)\" ]"
  check "shell starts without output"  "zsh -i -c exit 2>/dev/null"

  echo
  if [ "$fail" -ne 0 ]; then
    echo "SMOKE TEST FAILED" >&2
    exit 1
  fi
  echo "SMOKE TEST PASSED"
'
