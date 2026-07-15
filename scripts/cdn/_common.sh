#!/usr/bin/env bash
# Shared helpers for scripts/cdn/*.sh. Not meant to be executed directly.
set -euo pipefail

: "${BALADY_CURSORS_READ_PAR:=}"
: "${BALADY_CURSORS_WRITE_PAR:=}"

require_read_par() {
  if [[ -z "$BALADY_CURSORS_READ_PAR" ]]; then
    echo "error: BALADY_CURSORS_READ_PAR is not set" >&2
    exit 2
  fi
  if [[ "$BALADY_CURSORS_READ_PAR" != */o/cursors/ ]]; then
    echo "error: BALADY_CURSORS_READ_PAR must end with /o/cursors/" >&2
    exit 2
  fi
}

require_write_par() {
  if [[ -z "$BALADY_CURSORS_WRITE_PAR" ]]; then
    echo "error: BALADY_CURSORS_WRITE_PAR is not set" >&2
    exit 2
  fi
  if [[ "$BALADY_CURSORS_WRITE_PAR" != */o/cursors/ ]]; then
    echo "error: BALADY_CURSORS_WRITE_PAR must end with /o/cursors/" >&2
    exit 2
  fi
}

# Prints HTTP status only. Non-zero exit if the status is not 2xx.
expect_2xx() {
  local code="$1" name="$2"
  if [[ "$code" =~ ^2[0-9][0-9]$ ]]; then
    return 0
  fi
  echo "error: unexpected HTTP $code for $name" >&2
  return 1
}
