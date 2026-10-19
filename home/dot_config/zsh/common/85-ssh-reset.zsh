# Terminal hygiene: clear the modes a dropped ssh session leaves behind.
#
# When a network drop kills ssh, the remote application never restores the
# terminal modes it set — DEC Special Graphics charset (letters render as
# box-drawing), application keypad mode, mouse reporting, bracketed paste,
# alt screen, or the Kitty keyboard protocol. This runs after `command ssh`
# returns and resets all of them.
#
# The Kitty pop matters when the remote app was a TUI (e.g. pi): it pushes the
# protocol on startup and pops it on exit, so a crash leaves it active and your
# local shell starts receiving `CSI …u` sequences instead of real control bytes
# — Ctrl-C included. Popping twice is harmless (an empty stack ignores it) and
# covers an app that pushed more than once.
#
# Guarded by [[ -t 1 ]] so piped output (`ssh host cat f > out`) stays clean,
# and it preserves ssh's exit status so `$?`/`&&` keep working.

ssh() {
  command ssh "$@"
  local rc=$?
  if [[ -t 1 ]]; then
    stty sane 2>/dev/null
    printf '\033(B\033)B\033[0m\033[?25h\033[?1000l\033[?1002l\033[?1003l\033[?1006l\033[?1004l\033[?2004l\033[?1l\033>\033[?1049l\033[>4;0m\033[<u\033[<u'
  fi
  return $rc
}
