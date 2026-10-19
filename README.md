# dotfiles

Managed with [chezmoi](https://chezmoi.io). One configuration for macOS and Arch Linux.

## Bootstrap a new machine

```sh
git clone git@github.com:laurentlp/dotfiles.git ~/dotfiles && ~/dotfiles/bootstrap.sh
```

`bootstrap.sh` installs chezmoi if it is missing, then runs `chezmoi init`
(once, generating `~/.config/chezmoi/chezmoi.toml` with `sourceDir = $HOME/dotfiles`)
and `chezmoi apply`. Re-running it is safe.

Prerequisites: Homebrew on macOS (bootstrap stops with a message otherwise);
on Arch nothing but `sudo`, which the package step prompts for.

Packages are installed by `run_onchange_install-packages.sh` — on first apply and
again whenever that file changes. Required (the shell config expects them):

| | |
| --- | --- |
| both | chezmoi, starship, zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions, jump, the_silver_searcher, pyenv, nvm, direnv, neovim, ripgrep, fzf |
| Arch only | zsh (installs `github-cli`, not `gh`) |
| optional | tmux, mosh, jq, tree, fd, bat, eza, GitHub CLI |

macOS deliberately skips `zsh`: it is already the login shell there.

## Day to day

| Task | Command |
| --- | --- |
| Edit a managed file | `chezmoi edit ~/.zshrc` |
| See pending changes | `chezmoi diff` |
| Apply | `chezmoi apply` |
| Pull the repo and apply | `chezmoi update` (also available as `updatedotfiles`) |
| Adopt a file you edited in place | `chezmoi add ~/.config/foo` |

Never edit a managed file in place: the next `chezmoi apply` reverts it.

## Layout

```
bootstrap.sh                           → fresh-machine entry point (not placed in $HOME)
dot_zshrc                              → ~/.zshrc          (two-phase loader)
dot_config/zsh/common/*.zsh            → shared fragments  (00-* run BEFORE compinit)
dot_config/zsh/darwin/*.zsh            → macOS only        (brew paths, plugin sourcing)
dot_config/zsh/linux/*.zsh             → Arch only         (paths, plugin sourcing)
dot_gitconfig.tmpl                     → ~/.gitconfig      (name/email from .chezmoi.toml.tmpl)
dot_gitignore_global                   → ~/.gitignore_global
private_dot_ssh/private_config.tmpl    → ~/.ssh/config     (0600; UseKeychain on macOS only)
dot_local/bin/executable_*             → ~/.local/bin/*
run_onchange_install-packages.sh.tmpl  → package install, per OS
```

## Ordering rules

- `compinit` runs in `dot_zshrc` **before** phase 2, because `50-git-aliases.zsh`
  calls `compdef`.
- `00-*.zsh` fragments run **before** `compinit` — that is where `fpath` additions
  belong (`zsh-completions`, Docker completions).
- `zsh-syntax-highlighting` must be sourced **last**; that is why it lives in the
  `10-plugins.zsh` of each OS directory, which loads after all of `common/`.
- `zmodload zsh/complist` is required for the `menu select` style in `40-zstyles.zsh`.

## What differs per OS

Exactly three things, each with one home:

1. **Packages and their install paths** → `darwin/` + `linux/` fragments and the install script.
2. **`UseKeychain`** in ssh config → one `{{ if eq .chezmoi.os "darwin" }}` block.
3. **Identity** → `.chezmoi.toml.tmpl`.

Everything else is a plain shared file. Do not add templating unless the value
genuinely differs per machine — that is the main way chezmoi repos rot.

## History

The `pre-chezmoi` tag marks the previous model: `./setup` symlinks, a vendored
(and gitignored) oh-my-zsh, powerlevel10k, and a hand-maintained `sshconfig` that
`setup` would copy over `~/.ssh/config`. `git show pre-chezmoi` still has it.

`fonts/` is kept in the repo but excluded from chezmoi via `.chezmoiignore`;
install a Nerd Font in your terminal emulator instead of relying on those files.
