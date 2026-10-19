# Tool integrations that are identical on every machine.
#
# Every line is guarded by a command check, so a machine that lacks the tool
# simply skips it instead of erroring on every shell start (pyenv and direnv
# were unguarded before and did exactly that wherever they were missing).

# jump — directory jumper. `jump shell` alone only prints instructions; the
# shell name is required for it to emit the function.
(( $+commands[jump] )) && eval "$(jump shell zsh)"

# pyenv — Python version manager; puts its shims on PATH.
(( $+commands[pyenv] )) && eval "$(pyenv init -)"

# direnv — per-directory environments.
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"
