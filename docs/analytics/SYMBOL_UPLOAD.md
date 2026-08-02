# Symbol upload for crash reporting (PostHog)

Companion to the crash-reporting section of
[analytics-tracking-plan.md](../analytics-tracking-plan.md). This describes the CI
wiring that makes **native** crash stacks readable, and the one-time setup it needs.

## Why this exists

The code that runs on a device is not the code we wrote:

- **Android** — R8 renames Java/Kotlin symbols in release builds
  (`minifyEnabled true` in `android/app/build.gradle`), so a crash frame arrives as
  `a.b(Unknown Source:12)`. The `mapping.txt` R8 emits maps the short names back.
- **iOS** — release binaries ship stripped of their symbol table, so a crash is a list
  of addresses (`0x1045c8a10 Runner + 1234567`). The `dSYM` bundle Xcode emits carries
  the table. PostHog matches crash to dSYM by the binary's **UUID**.

Neither file ships inside the app: a dSYM is hundreds of megabytes, and shipping
`mapping.txt` would defeat obfuscation. They stay in CI and are uploaded to PostHog,
which applies them when rendering a stack.

**Symbols are per build.** A dSYM or mapping from another build symbolicates nothing —
the UUID/version will not match. So the upload has to happen on every release build,
and a build shipped without it stays unreadable forever.

Scope note: this only affects **native** frames. Dart frames are already readable
because CI does not pass `--obfuscate`, and that is most of what we capture.

## What is already wired (no action needed)

| Where | What it does |
|---|---|
| `android/settings.gradle` | declares the `com.posthog.android` Gradle plugin (1.4.0) |
| `android/app/build.gradle` | applies it **only** when `POSTHOG_CLI_API_KEY` is set |
| `.github/workflows/android-manual-build.yaml` | installs `posthog-cli`, passes host/project/key; project id is picked per flavor |
| `.github/scripts/upload_ios_symbols.sh` | uploads the dSYMs of the build that just finished |
| `.github/workflows/ios.yaml` | installs `posthog-cli`, calls the script after each of the three `flutter build ipa` runs |

Both paths are **fail-open**: without credentials the upload is skipped and the build
is unchanged. A failed upload logs a warning and never fails a release.

## One-time setup — what you need to do

**1. Create a personal API key** (PostHog UI → Personal settings → Personal API keys).
Scopes required: `error tracking: write` and `organization: read`. One key covers all
projects in the organisation. This is a *personal* key (`phx_…`), not the public
`phc_…` write key in `.env.<flavor>` — treat it as a secret, it is not client-safe.

**2. Collect the numeric project ids.** PostHog UI → Project settings; the id is also
the number in the dashboard URL (`/project/<id>/…`). You need two: the prod project,
and the one shared by stg/pre/urbiPre.

## What devops needs to do

In GitHub → repository Settings:

**Secrets** (Settings → Secrets and variables → Actions → *Secrets*):

| Name | Value |
|---|---|
| `POSTHOG_CLI_API_KEY` | the personal API key from step 1 |

**Variables** (same page → *Variables* tab — these are ids, not secrets):

| Name | Value |
|---|---|
| `POSTHOG_PROJECT_ID_PROD` | numeric id of the prod project |
| `POSTHOG_PROJECT_ID_STG` | numeric id of the stg/pre project |

Notes for whoever sets this up:

- The runner needs **Node.js** available so `npm install -g @posthog/cli` works. The
  install step is `continue-on-error`, so a runner without npm degrades to "no symbol
  upload" rather than a red build — worth checking the step actually succeeds the first
  time rather than assuming it did.
- The upload host is `https://eu.posthog.com` (the app host), **not**
  `eu.i.posthog.com` (the ingest host used by the SDK). It is hardcoded per platform in
  the workflow/script; only change it if the region changes.
- Nothing here needs the private pub registry or a VPN.

## Verifying it works

1. Run an Android build for `stg` and an iOS build; check the job logs for
   `Uploading dSYMs …` / the plugin's upload task. Absence of these lines means the
   secret is not visible to the job.
2. In PostHog → Error tracking → Symbol sets, the uploaded sets appear per release.
3. Real proof is a symbolicated stack: trigger a native crash on that exact build and
   confirm the frames show names, not `a.b()` or raw addresses.

## Known gaps

- **Android NDK (C/C++) crashes are not captured at all** by the SDK, so no amount of
  symbol uploading will surface a crash inside the map SDK's native layer.
- Apple native capture is upstream-experimental.
- Only the three CI-built flavors upload symbols. Locally built releases do not, by
  design.
