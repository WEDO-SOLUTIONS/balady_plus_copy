#!/usr/bin/env bash
# Delete one object from cursors/. Irreversible. Usage: delete.sh <remote-name>
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=_common.sh
source "$DIR/_common.sh"

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <remote-name>" >&2
  exit 2
fi

require_write_par

remote_name="$1"

code=$(curl -sS -o /dev/null -w '%{http_code}' -X DELETE \
  "${BALADY_CURSORS_WRITE_PAR}${remote_name}")
printf 'DELETE %s ... %s\n' "$remote_name" "$code"
expect_2xx "$code" "$remote_name"
