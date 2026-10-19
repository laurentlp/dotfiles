# dotfiles

Managed with [chezmoi](https://chezmoi.io). One configuration for macOS and Arch Linux.

## Bootstrap a new machine

```sh
git clone git@github.com:laurentlp/dotfiles.git ~/dotfiles && ~/dotfiles/bootstrap.sh
```

`bootstrap.sh` installs chezmoi if it is missing, runs `chezmoi init` once to
generate `~/.config/chezmoi/chezmoi.toml` (`sourceDir = ~/dotfiles`), then
`chezmoi apply`. Re-running it is a no-op. It is root-aware: it calls the package
manager directly when already root, so it works inside a container too.

Prerequisites: Homebrew on macOS (bootstrap stops with a message otherwise); on
Arch nothing beyond root for the package step.

### Verify it without a spare machine

```sh
scripts/test-bootstrap.sh
```

Runs `bootstrap.sh` in a clean `archlinux:latest` container and asserts the
result: zsh installed, `~/.zshrc` parses, every fragment parses, the other OS's
fragments are absent, `~/.ssh/config` is 0600, and `chezmoi status` is empty.
This is the only honest way to check the "one command on a fresh machine" claim.

## Packages

Installed by `run_onchange_before_install-packages.sh`, which re-runs whenever
that file changes:

| Scope | Packages |
| --- | --- |
| both | chezmoi, starship, zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions, the_silver_searcher, pyenv, nvm, direnv, neovim, ripgrep, fzf |
| macOS only | jump (Homebrew) |
| Arch only | zsh |
| optional | tmux, mosh, jq, tree, fd, bat, eza, GitHub CLI |

`jump` is **AUR-only on Arch** — not in `[core]/[extra]`. Because one unknown
name aborts the whole `pacman -S` transaction, it is installed separately: via
`yay`/`paru` when present, otherwise skipped with a hint. `75-integrations.zsh`
guards on the binary, so the shell works fine without it. The GitHub CLI is
packaged as `github-cli` on Arch, not `gh`.

## Day to day

| Task | Command |
| --- | --- |
| Edit a managed file | `chezmoi edit ~/.zshrc` |
| See pending changes | `chezmoi diff` |
| Apply | `chezmoi apply` |
| Pull the repo and apply | `chezmoi update` (also available as `updatedotfiles`) |
| Adopt a file you edited in place | `chezmoi add ~/.config/foo` |
| Check nothing is out of sync | `chezmoi status` (empty = clean) |

Never edit a managed file in place — chezmoi will prompt about it and revert it.
Use `chezmoi edit`.

## Layout

```
.chezmoiroot                    declares home/ as the chezmoi source root
bootstrap.sh                    fresh-machine entry point        (not managed)
scripts/test-bootstrap.sh       container smoke test             (not managed)
fonts/                          Nerd Font files, currently unused (not managed)
home/                           ─── the chezmoi source ───
  .chezmoiversion               minimum chezmoi version
  .chezmoiignore.tmpl           per-OS: hide the other OS's fragments
  .chezmoiremove.tmpl           paths chezmoi deletes on apply
  .chezmoi.toml.tmpl            generates ~/.config/chezmoi/chezmoi.toml (identity)
  dot_zshrc                     → ~/.zshrc                (two-phase loader)
  dot_config/zsh/common/*.zsh   → shared fragments         (00-* run BEFORE compinit)
  dot_config/zsh/darwin/*.zsh   → macOS only
  dot_config/zsh/linux/*.zsh    → Arch only
  dot_gitconfig.tmpl            → ~/.gitconfig             (name/email from .chezmoi.toml.tmpl)
  dot_gitignore_global          → ~/.gitignore_global
  private_dot_ssh/private_config.tmpl → ~/.ssh/config      (0600; UseKeychain on macOS only)
  dot_local/bin/executable_*    → ~/.local/bin/*
  run_onchange_before_install-packages.sh.tmpl → package install, per OS
```

## Ordering rules

- `compinit` runs in `dot_zshrc` **before** phase 2, because `50-git-aliases.zsh`
  calls `compdef`.
- `00-*.zsh` fragments run **before** `compinit` — that is where `fpath` additions
  belong (`zsh-completions`, Docker completions).
- `zsh-syntax-highlighting` must be sourced **last**; hence it lives in each OS
  directory's `10-plugins.zsh`, which loads after all of `common/`.
- `zmodload zsh/complist` is required for the `menu select` style in `40-zstyles.zsh`.

## What differs per OS

Exactly three things, each with one home:

1. **Packages and their install paths** → `darwin/` + `linux/` fragments and the install script.
2. **`UseKeychain`, `IdentityFile`** in ssh config, and the OS's own fragment directory → a few `{{ if }}` blocks in the ignore/ssh templates.
3. **Identity** → `.chezmoi.toml.tmpl`.

Everything else is a plain shared file. Do not add templating unless the value
genuinely differs per machine.

## Gotchas learned the hard way

- **`$HOME` mapping.** Every path in the source root maps into `$HOME`. That is
  why the source lives in `home/` and the repo root is free for README, scripts
  and fonts.
- **`.chezmoiignore` beats `.chezmoiremove`.** A path that is ignored cannot be
  removed by the move list; nothing happens, silently. The other OS's fragment
  directory is therefore cleaned once by hand (`rm -rf ~/.config/zsh/darwin` on
  Linux, `~/.config/zsh/linux` on macOS).
- **No `apply --prune`** (2.73.2). Removing or renaming a managed file leaves the
  target on disk — and a stale `dot_config/zsh/common/*.zsh` fragment keeps being
  sourced. Add the old path to `.chezmoiremove.tmpl`.
- **`.chezmoiscripts/` is not supported** in 2.73.2: files in it are copied into
  `$HOME` rather than run. Run scripts live in the source root, with a `before_`
  or `after_` phase prefix (packages install `before_` files land).
- **Hand-editing a managed file** makes chezmoi ask *"has changed since chezmoi
  last wrote it?"*; in a non-interactive context that aborts the apply.

- **Modified keys need the transport's cooperation.** `Shift+Enter` (and any
  modified key) depends on the terminal's Kitty keyboard protocol. `mosh` has no
  equivalent of tmux's `extended-keys`, so the handshake dies inside mosh-server
  and `Shift+Enter` arrives as a bare `CR` — a TUI like pi submits instead of
  inserting a newline. Use `ssh` for interactive work, mosh for long jobs.

## History

`pre-chezmoi` tags the older model: `./setup` symlinks, a vendored (gitignored)
oh-my-zsh, powerlevel10k, and a hand-maintained `sshconfig` that `setup` copied
over `~/.ssh/config`.
