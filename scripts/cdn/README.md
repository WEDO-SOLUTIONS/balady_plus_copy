# Navigation cursor CDN scripts

Small shell helpers for managing the GLB models under
`balady-plus-assets/cursors/` in OCI Object Storage (region `me-jeddah-1`,
namespace `axownvq9lhmx`). The app downloads these at runtime via
[`CursorDownloader`](../../mapness/lib/features/navigation_cursor/cursor_downloader.dart).

## Environment

Read-only PAR is bundled with the app (see `kCursorCdnBaseUrl` in the
Dart enum) and public — no secrets there. **Write-PAR is not stored
anywhere in the repo**; you keep it in `~/.config/balady/cdn.env` or export
it inline before running any script that mutates the bucket:

```
export BALADY_CURSORS_READ_PAR='https://objectstorage.me-jeddah-1.oraclecloud.com/p/.../n/axownvq9lhmx/b/balady-plus-assets/o/cursors/'
export BALADY_CURSORS_WRITE_PAR='https://objectstorage.me-jeddah-1.oraclecloud.com/p/.../n/axownvq9lhmx/b/balady-plus-assets/o/cursors/'
```

Both URLs end with `/o/cursors/` — scripts append the object name to that
prefix. Grab fresh PARs from OCI Console when the current ones expire
(`2027-07-06`).

## Scripts

- `list.sh` — enumerate everything currently under `cursors/`. Requires
  Write-PAR (listing is disabled on the public read PAR).
- `upload.sh <local-path> [remote-name]` — PUT one file. Remote name
  defaults to the basename of the local path.
- `download.sh <remote-name> [local-path]` — GET one file via the public
  read PAR. Works with only `BALADY_CURSORS_READ_PAR` exported.
- `delete.sh <remote-name>` — DELETE one object. Irreversible.
- `rename.sh <old-name> <new-name>` — server-side copy via read+write
  PARs (OCI PAR has no native rename); leaves the original in place, run
  `delete.sh` afterwards if you want to remove it.
- `bulk_upload.sh <local-dir>` — PUT every `*.glb` in `<local-dir>` under
  its basename. Skips files whose SHA256 already matches the remote copy.

Each script prints one line per object: `<action> <name> ... <http_code>`.
Exit code is non-zero if any single request returned anything other than
2xx.

## Cache-busting note

`CursorDownloader.isDownloaded()` in the app treats "file present locally"
as "up-to-date". Overwriting a GLB on the CDN under the **same** filename
does **not** invalidate existing installs — old bytes stay in
Application Support. To force refresh, either rename the file (and bump
`NavigationCursor.cdnFileName` in the enum) or add a version manifest
(FRC-based) — see the follow-up notes in
[`docs/features/BE-252-navigation-cursors.md`](../../docs/features/BE-252-navigation-cursors.md).
