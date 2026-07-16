#!/usr/bin/env bash
# Validates a PostHog instance without the app: sends one capture event.
# Usage: POSTHOG_HOST=https://153.80.192.8.sslip.io ./smoke_test.sh <phc_project_api_key>
set -euo pipefail

HOST="${POSTHOG_HOST:-https://153.80.192.8.sslip.io}"
KEY="${1:?usage: [POSTHOG_HOST=https://...] smoke_test.sh <phc_project_api_key>}"
STAMP="$(date +%s)"

curl -fsS -X POST "$HOST/i/v0/e/" -H 'Content-Type: application/json' -d "{
  \"api_key\": \"$KEY\",
  \"event\": \"infra_smoke_test\",
  \"distinct_id\": \"smoke-$STAMP\",
  \"properties\": {\"source\": \"smoke_test.sh\", \"stamp\": \"$STAMP\"}
}"
echo
echo "OK — event 'infra_smoke_test' accepted. Check Activity in the PostHog UI: $HOST"
