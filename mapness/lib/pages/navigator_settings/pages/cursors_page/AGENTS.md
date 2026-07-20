# AGENTS.md — cursors_page

UI for BE-252. Feature logic lives in
[`mapness/lib/features/navigation_cursor/`](../../../../features/navigation_cursor/AGENTS.md) —
this directory is the picker screen only.

## Layout constraints

- Two sections, both `ContentColumn` + `ContentWrapper`:
  - **Your cursors** — `classic` plus every downloaded id. Row is
    tappable if it's not the active one; active gets the checkmark SVG
    on the right (`ic_checkmark.svg`) and `onTap = null`.
  - **Available** — every not-yet-downloaded cursor. Row is tappable,
    trailing widget is `ic_download.svg`. Tap = download+apply in one
    gesture; UX intentionally does not require two taps.
- When a row is `busy` (matches `state.inProgress`) the trailing widget
  is a `CircularProgressIndicator(strokeWidth: 2)` inside a 20×20 box,
  and the tap is disabled. Do not disable the whole `ContentColumn` —
  the user should still be able to tap other rows if we ever lift the
  one-at-a-time restriction.
- Every trailing widget goes through `customActionWidget: Widget?` on
  `ContentRowOptions` — the balady_uikit
  `ContentRowActionOptions.actionIcon` field only accepts `AppIcons`
  (IconData-based), which cannot render arbitrary Figma SVGs. Do not
  refactor back to `actionWidget`.
- Section subtitle "Select navigator type" is a plain `Text` above the
  first `ContentColumn`, in `bodySmallRegular` + `foregroundSoft`. It is
  *not* a `ContentColumn.subtitle`.

## Error handling

- `ref.listen(navigationCursorControllerProvider, ...)` compares
  `next.lastError` to `previous?.lastError` — on new error, hide any
  current snackbar and show a fresh one, then call
  `controller.clearError()`. The state must remain clean so navigating
  away and back doesn't re-fire.
- Do not display errors inline in the row. The row rolls back visually
  (busy → not-busy) and the snackbar carries the message.

## Route

- Registered in `mapness/lib/app/auto_route/app_routes.dart` as
  `CursorsRoute` under path `cursors`, cupertino transition.
- The picker uses `@RoutePage()` on `CursorsPage`; editing that
  annotation requires `dart run build_runner build`.

## Assets

- Thumbnails live in `assets/icons/cursors/thumb_*.png`, registered in
  the root `pubspec.yaml` under `assets/icons/cursors/`. If you add a
  cursor you must ship the PNG and reference it via
  `NavigationCursor.thumbnailAsset`.
- Trailing SVGs `ic_checkmark.svg` / `ic_download.svg` live in the same
  directory and are rendered via `flutter_svg`. The hardcoded paths in
  `cursors_page_content.dart` are on purpose — there are exactly two
  states, no reason to introduce an enum for them.
