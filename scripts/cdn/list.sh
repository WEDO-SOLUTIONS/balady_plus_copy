#!/usr/bin/env bash
# List objects under cursors/ in the OCI bucket.
# Requires BALADY_CURSORS_WRITE_PAR (listing is disabled on the read-only PAR).
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=_common.sh
source "$DIR/_common.sh"

require_write_par

# Strip trailing `cursors/` to hit the bucket root, then append ?listObjects=1
# and prefix filter. OCI Native listing via PAR uses the /o/ endpoint of the
# PAR itself.
base="${BALADY_CURSORS_WRITE_PAR%cursors/}"
url="${base}?listObjects=1&prefix=cursors/"

curl -sSL "$url" | python3 -c '
import json, sys
data = json.load(sys.stdin)
for obj in data.get("objects", []):
    print(obj["name"])
'
