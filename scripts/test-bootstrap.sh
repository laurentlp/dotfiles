#!/bin/sh
# Smoke-test bootstrap.sh on a clean Arch container.
#
#   scripts/test-bootstrap.sh
#
# This is the only way to verify the "one command on a fresh machine" claim
# without a spare box: a real archlinux image, no shell config, no chezmoi.
# It mounts the repo read-only, copies it to /root, runs bootstrap.sh, and
# asserts the result is sane.
set -eu

repo=$(cd "$(dirname "$0")/.." && pwd)
image=${IMAGE:-archlinux:latest}

command -v docker >/dev/null 2>&1 || {
  echo "docker not found — install it or run this on a machine that has it." >&2
  exit 1
}

echo "==> building a clean $image with the repo at /root/dotfiles" >&2

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
  check() { if eval "$2"; then printf "  ok    %s\n" "$1"; else printf "  FAIL  %s\n" "$1"; fail=1; fi; }
  check "zsh installed"              "command -v zsh >/dev/null"
  check "starship installed"         "command -v starship >/dev/null"
  check "~/.zshrc is a real file"    "test -f /root/.zshrc && test ! -L /root/.zshrc"
  check "~/.zshrc parses"            "zsh -n /root/.zshrc"
  check "every fragment parses"      "for f in /root/.config/zsh/common/*.zsh; do zsh -n \"$f\" || exit 1; done"
  check "linux fragments present"    "test -f /root/.config/zsh/linux/00-paths.zsh"
  check "darwin fragments absent"    "test ! -e /root/.config/zsh/darwin"
  check "ssh config mode 0600"       "[ \"$(stat -c %a /root/.ssh/config)\" = 600 ]"
  check "gitconfig rendered"         "grep -q \"$(printf \"\t\")\" /root/.gitconfig 2>/dev/null; test -s /root/.gitconfig"
  check "chezmoi reports clean"      "[ -z \"$(chezmoi status)\" ]"
  check "shell starts without error" "zsh -i -c exit 2>/dev/null"

  echo
  if [ "$fail" -ne 0 ]; then echo "SMOKE TEST FAILED" >&2; exit 1; fi
  echo "SMOKE TEST PASSED"
'
