# Environment — identical on every machine.

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Prefer nvim, fall back to vim/vi. This config is shared by machines that do
# not necessarily have the same editors installed, and git execs $EDITOR
# directly (no shell, so aliases like `vi=nvim` never apply there).
if (( $+commands[nvim] )); then
  export EDITOR='nvim' VISUAL='nvim'
elif (( $+commands[vim] )); then
  export EDITOR='vim' VISUAL='vim'
else
  export EDITOR='vi' VISUAL='vi'
fi

# TERM is deliberately NOT forced. bear's old zshrc pinned `TERM=xterm` so that
# powerlevel10k would fall back to 16 colours; with the Base16 palette pushed
# via OSC 4 (70-colours.zsh), the terminal's real TERM (xterm-256color) is what
# we want, and starship renders identically on both machines.
