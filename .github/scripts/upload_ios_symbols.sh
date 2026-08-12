#!/usr/bin/env bash
#
# Uploads the dSYM bundles of the iOS build that just finished to PostHog, so
# native crash reports show function names and line numbers instead of bare
# addresses. Release binaries ship stripped; the dSYM carries the symbol table,
# and PostHog matches the two by the binary's UUID.
#
# Usage:  .github/scripts/upload_ios_symbols.sh <posthog-project-id>
#
# Must run immediately after each `flutter build ipa`: every build overwrites
# build/ios/archive/Runner.xcarchive, and symbols from a different build are
# useless — a mismatched UUID symbolicates nothing.
#
# Wraps the uploader shipped inside the PostHog pod, which calls
# `posthog-cli dsym upload` and derives the release name/version from the app's
# Info.plist. Requires POSTHOG_CLI_API_KEY (personal API key with "error
# tracking write" + "organization read") in the environment.
#
# Never fails the build: crash-report readability is not worth losing a release
# over. Missing credentials or a missing archive are reported and skipped.
#
# See docs/analytics/SYMBOL_UPLOAD.md.

set -uo pipefail

PROJECT_ID="${1:-}"
UPLOADER="ios/Pods/PostHog/build-tools/upload-symbols.sh"
ARCHIVE_DSYMS="build/ios/archive/Runner.xcarchive/dSYMs"

if [ -z "${POSTHOG_CLI_API_KEY:-}" ]; then
  echo "note: POSTHOG_CLI_API_KEY not set — skipping dSYM upload."
  exit 0
fi

if [ -z "$PROJECT_ID" ]; then
  echo "warning: no PostHog project id passed — skipping dSYM upload."
  exit 0
fi

if [ ! -x "$UPLOADER" ]; then
  echo "warning: $UPLOADER not found or not executable (pod install ran?) — skipping dSYM upload."
  exit 0
fi

if [ ! -d "$ARCHIVE_DSYMS" ]; then
  echo "warning: $ARCHIVE_DSYMS not found — skipping dSYM upload."
  exit 0
fi

# The uploader normally runs as an Xcode build phase and reads these from the
# build environment. Invoked from CI it gets them explicitly; CONFIGURATION is
# left unset on purpose, which the uploader treats as "proceed".
export DWARF_DSYM_FOLDER_PATH="$ARCHIVE_DSYMS"
export DWARF_DSYM_FILE_NAME="Runner.app.dSYM"
export POSTHOG_CLI_HOST="${POSTHOG_CLI_HOST:-https://eu.posthog.com}"
export POSTHOG_CLI_PROJECT_ID="$PROJECT_ID"
# Re-running a workflow re-uploads identical symbol sets; skip rather than fail.
export POSTHOG_SKIP_ON_CONFLICT=1

echo "Uploading dSYMs from $ARCHIVE_DSYMS to PostHog project $PROJECT_ID"
if "$UPLOADER"; then
  echo "dSYM upload finished."
else
  echo "warning: dSYM upload failed — release stacks for this build stay unsymbolicated."
fi

exit 0
