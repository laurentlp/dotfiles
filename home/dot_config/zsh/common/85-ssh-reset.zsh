# Terminal hygiene: clear the modes a dropped ssh session leaves behind.
#
# When a network drop kills ssh, the remote application never restores the
# terminal modes it set — DEC Special Graphics charset (letters render as
# box-drawing), application keypad mode, mouse reporting, bracketed paste,
# alt screen. This runs after `command ssh` returns and resets all of them.
#
# Guarded by [[ -t 1 ]] so piped output (`ssh host cat f > out`) stays clean,
# and it preserves ssh's exit status so `$?`/`&&` keep working.

ssh() {
  command ssh "$@"
  local rc=$?
  if [[ -t 1 ]]; then
    stty sane 2>/dev/null
    printf '\033(B\033)B\033[0m\033[?25h\033[?1000l\033[?1002l\033[?1003l\033[?1006l\033[?1004l\033[?2004l\033[?1l\033>\033[?1049l'
  fi
  return $rc
}
