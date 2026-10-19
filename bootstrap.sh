#!/bin/sh
# One-command setup for a fresh machine.
#
#   git clone git@github.com:laurentlp/dotfiles.git ~/dotfiles && ~/dotfiles/bootstrap.sh
#
# Installs chezmoi if it is missing, then applies everything (the package
# install runs from chezmoi's own run_onchange script). Idempotent: re-running
# is safe and changes nothing on an up-to-date machine.
set -eu

src=$(cd "$(dirname "$0")" && pwd)
config="$HOME/.config/chezmoi/chezmoi.toml"

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
      echo "Installing chezmoi (root required)..." >&2
      sudo pacman -S --needed --noconfirm chezmoi
      ;;
  esac
fi

# init writes ~/.config/chezmoi/chezmoi.toml (sourceDir = this clone).
# Never overwrite an existing one: it may hold local identity overrides.
[ -f "$config" ] || chezmoi --source "$src" init

chezmoi --source "$src" apply -v
