# Environment — identical on every machine.

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='nvim'
export VISUAL='nvim'

# TERM is deliberately NOT forced. bear's old zshrc pinned `TERM=xterm` so that
# powerlevel10k would fall back to 16 colours; with the Base16 palette pushed
# via OSC 4 (70-colours.zsh), the terminal's real TERM (xterm-256color) is what
# we want, and starship renders identically on both machines.
