# Machine-local additions that live outside the repo.
#
# Coding-agent profile wrappers (oc, etc.). Present on both machines but at
# different paths, and it is not something chezmoi manages — hence the guard.

[[ -r "$HOME/agents/shell/agents.sh" ]] && source "$HOME/agents/shell/agents.sh"
