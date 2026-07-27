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

Every patch is marked with `BALADY-3755` in a comment at the site.

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
stays readable.
