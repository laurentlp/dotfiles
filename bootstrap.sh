#!/bin/sh
# One-command setup for a fresh machine.
#
#   git clone git@github.com:laurentlp/dotfiles.git ~/dotfiles && ~/dotfiles/bootstrap.sh
#
# Installs chezmoi if it is missing, then applies everything (the package
# install runs from chezmoi's own run_onchange script). Idempotent: re-running
# is a no-op on an up-to-date machine.
set -eu

src=$(cd "$(dirname "$0")" && pwd)
config="$HOME/.config/chezmoi/chezmoi.toml"

# Run a package-manager install as root: directly when already root (containers,
# CI), through sudo otherwise. Keeps this script usable from a throwaway image
# where sudo is not installed.
as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

if ! command -v chezmoi >/dev/null 2>&1; then
  case "$(uname -s)" in
    Darwin)
      command -v brew >/dev/null 2>&1 || {
        echo "Homebrew required: install from https://brew.sh first." >&2
        exit 1
      }
      brew install chezmoi
      ;;
    *)
      command -v pacman >/dev/null 2>&1 || {
        echo "Unsupported system $(uname -s) — install chezmoi manually." >&2
        exit 1
      }
      echo "Installing chezmoi..." >&2
      as_root pacman -S --needed --noconfirm chezmoi
      ;;
  esac
fi

# init writes ~/.config/chezmoi/chezmoi.toml (sourceDir = this clone).
# Never overwrite an existing one: it may hold local identity overrides.
[ -f "$config" ] || chezmoi --source "$src" init

chezmoi --source "$src" apply -v
