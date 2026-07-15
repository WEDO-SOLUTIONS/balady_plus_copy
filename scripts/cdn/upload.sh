#!/usr/bin/env bash
# Upload a single GLB into cursors/. Usage: upload.sh <local-path> [remote-name]
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=_common.sh
source "$DIR/_common.sh"

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "usage: $0 <local-path> [remote-name]" >&2
  exit 2
fi

require_write_par

local_path="$1"
remote_name="${2:-$(basename "$local_path")}"

if [[ ! -f "$local_path" ]]; then
  echo "error: $local_path does not exist" >&2
  exit 2
fi

code=$(curl -sS -o /dev/null -w '%{http_code}' -X PUT \
  --data-binary "@$local_path" \
  -H 'Content-Type: model/gltf-binary' \
  "${BALADY_CURSORS_WRITE_PAR}${remote_name}")
printf 'PUT %s -> %s ... %s\n' "$local_path" "$remote_name" "$code"
expect_2xx "$code" "$remote_name"
