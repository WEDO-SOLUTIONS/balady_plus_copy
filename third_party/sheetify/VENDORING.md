# Vendored `sheetify`

## What this is

A **vendored source copy** of the `sheetify` package, patched locally and wired
into the build through `dependency_overrides` in the root `pubspec.yaml`.

This is **not a git fork**. Nothing was forked on GitHub and there is no git
remote behind this directory — it is a snapshot of the published pub.dev
archive, committed into this repository. If the patches below grow or need to
be shared with other consumers, the right move is to fork
`https://github.com/urbi-ae/sheetify` properly and switch the override to a git
dependency.

## Provenance

| | |
| --- | --- |
| Upstream | https://github.com/urbi-ae/sheetify |
| Source | `pub.dev` archive `sheetify 1.1.3` |
| Copied from | `~/.pub-cache/hosted/pub.dev/sheetify-1.1.3` |
| Vendored at | 2026-07-27 |

Only `lib/` plus `pubspec.yaml`, `LICENSE`, `CHANGELOG.md`, `README.md` and
`analysis_options.yaml` were copied. `example/` (70 MB of build artifacts) and
`test/` were deliberately left out, so this directory is ~344 KB.

The first commit of this directory is byte-identical to the published 1.1.3
`lib/`, so `git log` on any file here shows exactly what we changed and why.

## Why it exists

BALADY-3755 / BALADY-3768: a gray full-screen panel with no content after
sharing from a sheet on iOS. See the commit that follows the initial import for
the analysis; in short, `ToggleSheet` sized itself against the *system*
keyboard rather than its own, so a share extension's keyboard collapsed our
layout into non-normalized constraints.

## Local patches

| File | Change |
| --- | --- |
| `lib/toggle_sheet/render_toggle_sheet.dart` | `viewBottomPadding` bounded by the inset Flutter reports for this view — a keyboard that is not ours must not resize our layout |
| `lib/toggle_sheet/render_toggle_sheet.dart` | `avaliableHeight` clamped to `>= 0` so a collapsed viewport cannot produce `BoxConstraints(NOT NORMALIZED)` |
| `lib/toggle_sheet/toggle_sheet_controller.dart` | `fraction` guarded against division by a zero `maxHeight`, clamped to `[0, 1]` |
| `lib/multi_state_sheet/multi_state_sheet_controller.dart` | `fraction` guarded against division by a zero `viewportHeight`, clamped to `[0, 1]` |
| `lib/multi_state_sheet/state_snapping/behaviors/snapping_behavior.dart` | `stateToIndex` clamped to the offsets-list bounds: the deduplicated `snappingOffsets` set can transiently hold fewer entries than the sheet has states, and the negative index used to reach `elementAtOrNull`, which throws `RangeError` (crashed layout in release; the removed assert fired for the same legitimate geometry). Regression test: `test/bugfixes/balady_3914_snapping_state_clamp_test.dart` in the repo root |
| `lib/multi_state_sheet/render_multi_state_sheet.dart` | A transparent `outside` is re-laid out with its previous constraints instead of being skipped, which left a relayout inside it dirty under the sheet's relayout boundary and tripped `_debugRelayoutBoundaryAlreadyMarkedNeedsLayout` on the next one. Regression test: `test/bugfixes/balady_3978_sheet_outside_layout_test.dart` in the repo root |

Every patch is marked with its ticket ID (`BALADY-3755`, `BALADY-3914`, `BALADY-3978`) in a comment at the site.

## Keeping the toolchain off this code

This repo analyses at 120 columns and formats with `dart format -l 120`; upstream
`sheetify` is formatted at 80. Reflowing it would bury the four patches above under
a few hundred lines of noise and break the byte-for-byte comparison against a future
pub.dev release. So instead:

| Change | Why |
| --- | --- |
| `// dart format off` on line 1 of every file under `lib/` | The formatter leaves the file alone, so it stays as published |
| `environment.sdk` raised from `>=3.5.0` to `>=3.7.0` in `pubspec.yaml` | The `dart format off` marker only exists in the 3.7 formatter. Below that language version the marker is ignored and the files get reflowed |
| Two removed lints dropped from `analysis_options.yaml` | `unsafe_html` and `package_api_docs` were removed in Dart 3.7 and now report `removed_lint` warnings |

The SDK bump is safe here: this copy is only ever consumed by this app, which
already requires Dart >= 3.8. Analysis is clean under both 3.7 and 3.10 semantics,
so nothing in the package depends on pre-3.7 behaviour.

## Any CI job that generates `pubspec_overrides.yaml` has to repeat the override

The lint job on this branch reaches the private registry through `/etc/hosts` and
then runs a plain `flutter pub get` at the repo root, so the `dependency_overrides`
in `pubspec.yaml` apply and `package:sheetify` resolves here. Nothing to do.

Other branches solve the registry problem differently: `development`'s lint job runs
on `ubuntu-latest` with no route to unpub, so it writes a `pubspec_overrides.yaml`
with git dependencies instead. **`pubspec_overrides.yaml` replaces the whole
`dependency_overrides` block of `pubspec.yaml` rather than merging with it**, which
silently drops the `sheetify` entry. The job then resolves `package:sheetify` to the
pub.dev release while these files sit on disk, every
`part of 'package:sheetify/...'` detaches from its library, and the analyzer reports
~700 errors that have nothing to do with the code.

So if this directory is ever merged into a branch whose CI generates that file, add

```yaml
sheetify:
  path: third_party/sheetify        # ../third_party/sheetify in mapness/
```

to every generated `pubspec_overrides.yaml`.

## Known upstream issues we did **not** patch

- `performResize` calls `updateSize(isClosed ? maxHeight : 0.0)`. Offset `0`
  means "fully expanded", so any genuine host resize (rotation, iPad
  multitasking) snaps an open sheet to the top of the screen. Not reproduced
  here, so left alone.
- `ToggleSheetController.open()` is a no-op when `!isClosed`, which makes it
  useless for re-snapping a sheet that is already stuck open.

## Updating or removing

Take these patches upstream. Once they are in a published release, delete this
directory and drop the `sheetify` entry from `dependency_overrides` in the root
`pubspec.yaml`.

To re-vendor a newer version, copy the same subset from the pub cache, commit
that verbatim first, then re-apply the patches as a separate commit so the diff
stays readable. Re-apply the toolchain changes as well:

```bash
# from third_party/sheetify
for f in $(find lib -name '*.dart'); do
  head -1 "$f" | grep -q 'dart format off' || sed -i '' '1i\
// dart format off
' "$f"
done
```

then raise `environment.sdk` to `>=3.7.0` and re-check `analysis_options.yaml` for
lints the current SDK has removed. Verify with:

```bash
dart analyze third_party/sheetify && dart format --output=none --set-exit-if-changed -l 120 third_party/sheetify
```
