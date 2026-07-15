#!/usr/bin/env bash
# Download a single GLB from cursors/ via the public read PAR.
# Usage: download.sh <remote-name> [local-path]
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=_common.sh
source "$DIR/_common.sh"

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "usage: $0 <remote-name> [local-path]" >&2
  exit 2
fi

require_read_par

remote_name="$1"
local_path="${2:-$remote_name}"

code=$(curl -sSL -o "$local_path" -w '%{http_code}' \
  "${BALADY_CURSORS_READ_PAR}${remote_name}")
printf 'GET %s -> %s ... %s\n' "$remote_name" "$local_path" "$code"
expect_2xx "$code" "$remote_name"
