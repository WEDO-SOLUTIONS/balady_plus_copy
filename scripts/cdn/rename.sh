#!/usr/bin/env bash
# Server-side rename via read+write PARs: GET old, PUT new.
# Leaves the original in place — run delete.sh afterwards if desired.
# Usage: rename.sh <old-name> <new-name>
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=_common.sh
source "$DIR/_common.sh"

if [[ $# -ne 2 ]]; then
  echo "usage: $0 <old-name> <new-name>" >&2
  exit 2
fi

require_read_par
require_write_par

old="$1"
new="$2"
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

get_code=$(curl -sSL -o "$tmp" -w '%{http_code}' \
  "${BALADY_CURSORS_READ_PAR}${old}")
expect_2xx "$get_code" "$old"

put_code=$(curl -sS -o /dev/null -w '%{http_code}' -X PUT \
  --data-binary "@$tmp" \
  -H 'Content-Type: model/gltf-binary' \
  "${BALADY_CURSORS_WRITE_PAR}${new}")
printf 'RENAME %s -> %s ... GET=%s PUT=%s\n' "$old" "$new" "$get_code" "$put_code"
expect_2xx "$put_code" "$new"
