# AGENTS.md — cursors_page

UI for BE-252. Feature logic lives in
[`mapness/lib/features/navigation_cursor/`](../../../../features/navigation_cursor/AGENTS.md) —
this directory is the picker UI only.

## Two presentation modes, one content widget

`CursorsPageContent` renders in two hosts; the flags exist because the
hosts have different scroll and header ownership:

| Host | File | Figma | Flags |
| --- | --- | --- | --- |
| Full page (Settings → Navigator Settings → Cursors) | `cursors_page.dart` (`CursorsRoute`) | 2287-3295 | defaults |
| Bottom sheet (tap on the nav cursor during guidance / free roam, BALADY-3764) | `cursors_sheet.dart` (`showCursorsSheet`) | 2287-3140 | `scrollable: false, showHeader: false` |

- `scrollable: false` — the sheetify `ToggleSheet` puts content into its
  own SliverList; a nested `SingleChildScrollView` would swallow the
  sheet's drag gestures.
- `showHeader: false` — the sheet renders "Your cursors" + subtitle in
  its own *pinned* header (title + `AppCloseButton`), so the content
  must not repeat them. The full page keeps them inline.

## Sheet specifics (`cursors_sheet.dart`, BALADY-3771)

- Modal route: `showModalBottomSheet` (transparent) + `ToggleSheet`,
  same pattern as `EndTripModal`. Swipe-down and the close button both
  pop via `useToggleSheetController(onClose: pop)`.
- Background is `backgroundSurface2` (Figma) — **not** surface4 like the
  full page. Dragger and safe area use the same color.
- Close button is the shared `AppCloseButton`
  (`shared/ui/buttons/app_close_button.dart`): 44px, surface1, radius 8,
  `SystemIcons.close` in `foregroundDefault`, soft Figma shadow, and a
  transparent `Material` underneath (the default white one peeked out of
  the rounded corners on dark surfaces). It is used by other sheets too
  — restyle only against the Figma "Elements / wrapper" component.
- Landscape (BALADY-3763): the sheet pins to the leading edge at
  `NaviSheetPanel.landscapeWidth` + horizontal safe-area insets, like
  every navi panel. The full page instead caps content at
  `_maxContentWidth` (600) and centers it.
- Subtitle string: Figma 2287-3140 says "Select icon for navigation",
  but only `selectNavigatorType` exists in Localazy — the sheet reuses
  it until design supplies a dedicated key.
- **Bottom gutter.** The sheet content is wrapped in `SafeAreaPadding`
  (`shared/ui/safe_area_padding.dart`) with
  `minimum: EdgeInsets.only(bottom: Spacing.$3x)`, bottom side only.
  `ToggleSheet(useSafeArea: false)` sits flush with the physical screen
  edge, and sheetify's `safeAreaColor` is a *paint*-only strip —
  `RenderToggleSheet.performLayout` computes
  `avaliableHeight = constraints.maxHeight` and reserves no height for
  it. Without the wrapper the last row ends at the screen bottom with
  only the Figma 16 beneath it.
  Use `max(inset, minimum)`, never the bare inset and never a bare
  constant: a bottom inset is not a platform property. Android in
  3-button mode (and any non-edge-to-edge build) reports 0 just like an
  iPhone SE, while gesture nav and the iPhone 17 Pro Max home indicator
  report 24–48. `Spacing.$3x` is the same stable inset the navi panels
  fall back to (`NaviSheetPanel.paddingDelegate`, `road_panel.dart`).
  The full page needs none of this — it is already inside a `SafeArea`,
  which zeroes `MediaQuery.padding` for the shared content widget.

## Layout constraints (BALADY-3762)

- Section headers "Your cursors" / "Available" are `h4SemiBold` +
  `foregroundDefault` plain `Text`s — **not** `ContentColumn`
  (its header renders 13px caption and QA flagged the screen as
  compressed). Subtitle sits 2px under "Your cursors" in
  `bodySmallRegular` + `foregroundSoft`.
- Explicit gaps: header→subtitle 2, subtitle→card 16, card→"Available"
  12, "Available"→card 16; outer padding is `EdgeInsets.all(16)`
  including the bottom (do not `copyWith(bottom: 0)` — QA bug).
- Rows via `ContentWrapper`: divider only *between* rows
  (`dividerEnabled: i < length - 1`), never after the last or on a
  single row.
- Thumbnails are 28px (`_CursorThumbnail._size`), per Figma slot size.
- **Your cursors** — `classic` plus every downloaded id. Active row gets
  the checkmark SVG and `onTap = null`; others tap-to-apply.
- **Available** — not-yet-downloaded cursors, trailing `ic_download.svg`.
  Tap = download+apply in one gesture, intentionally not two taps.
- When a row is `busy` (`state.inProgress`) the trailing widget is a
  20×20 `CircularProgressIndicator(strokeWidth: 2)` and the tap is
  disabled; other rows stay tappable.
- Every trailing widget goes through `customActionWidget: Widget?` on
  `ContentRowOptions` — balady_uikit's `actionIcon` only accepts
  `AppIcons` (IconData) and cannot render the Figma SVGs. Do not
  refactor back.

## Error handling

- `ref.listen(navigationCursorControllerProvider, ...)` compares
  `next.lastError` to `previous?.lastError` — on new error, hide any
  current snackbar, show a fresh one, then `controller.clearError()` so
  navigating away and back doesn't re-fire.
- No inline row errors: the row rolls back (busy → not-busy) and the
  snackbar carries the message.

## Entry points / routing

- `CursorsRoute` in `app_routes.dart`, path `cursors`, cupertino
  transition; `@RoutePage()` on `CursorsPage` (codegen on annotation
  change).
- Map-tap entry: `map_tap_handler_provider.dart` →
  `_handleMyLocationTapEvent`. When the top route is `PathNavRoute` or
  `FreeRoamRoute` it calls
  `showCursorsSheet(rootNavigatorKey.currentContext)`; everywhere else
  the share-location card opens. The native short-tap plumbing lives in
  both `ObjectTapHandler`s (`urbi_map/dgis_map`, Android + iOS) —
  `MyLocationMapObject` must stay handled in the *short*-tap listeners;
  long-tap-only was the original BALADY-3764 bug.

## Assets

- Thumbnails `assets/icons/cursors/thumb_*.png` (root `pubspec.yaml`,
  `assets/icons/cursors/`). New cursor ⇒ ship the PNG and reference via
  `NavigationCursor.thumbnailAsset`.
- Trailing SVGs `ic_checkmark.svg` / `ic_download.svg`, plus
  `ic_cursor_nav.svg` (leading glyph of the Cursors row in Navigator
  Settings, tinted `accentDefault` at runtime — BALADY-3761). Hardcoded
  paths in `cursors_page_content.dart` are on purpose.
