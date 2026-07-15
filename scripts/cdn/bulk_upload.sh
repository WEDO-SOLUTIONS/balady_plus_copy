#!/usr/bin/env bash
# Upload every *.glb in <local-dir> under its basename, skipping files whose
# SHA256 already matches the remote copy.
# Usage: bulk_upload.sh <local-dir>
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=_common.sh
source "$DIR/_common.sh"

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <local-dir>" >&2
  exit 2
fi

require_read_par
require_write_par

src_dir="$1"
if [[ ! -d "$src_dir" ]]; then
  echo "error: $src_dir is not a directory" >&2
  exit 2
fi

shopt -s nullglob
files=("$src_dir"/*.glb)
if [[ ${#files[@]} -eq 0 ]]; then
  echo "no .glb files under $src_dir" >&2
  exit 0
fi

status=0
for f in "${files[@]}"; do
  name="$(basename "$f")"
  local_sha=$(shasum -a 256 "$f" | awk '{print $1}')
  remote_sha=$(curl -sSL "${BALADY_CURSORS_READ_PAR}${name}" 2>/dev/null | shasum -a 256 | awk '{print $1}' || true)
  if [[ "$local_sha" == "$remote_sha" ]]; then
    printf 'SKIP %-30s (sha256 match)\n' "$name"
    continue
  fi
  code=$(curl -sS -o /dev/null -w '%{http_code}' -X PUT \
    --data-binary "@$f" \
    -H 'Content-Type: model/gltf-binary' \
    "${BALADY_CURSORS_WRITE_PAR}${name}")
  printf 'PUT  %-30s ... %s\n' "$name" "$code"
  if ! expect_2xx "$code" "$name" 2>/dev/null; then
    status=1
  fi
done
exit "$status"
