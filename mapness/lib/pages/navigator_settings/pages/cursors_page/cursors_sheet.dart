import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/pages/navigator_settings/pages/cursors_page/cursors_page_content.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/shared/ui/safe_area_padding.dart';
import 'package:mapness/widgets/path_nav/ui/navi_sheet_panel.dart';
import 'package:sheetify/sheetify.dart';

/// BALADY-3923: a tap-and-hold on the navigation cursor delivers more than
/// one `onMyLocationTap` event natively (long-press plus the tap on
/// release), and each one used to call [showCursorsSheet] independently,
/// stacking several sheets. Guard with a single "is open" flag so repeated
/// calls while the sheet is still up are ignored.
bool _isCursorsSheetOpen = false;

/// BALADY-3960: a finger held over the my-location cursor keeps re-firing
/// native `onMyLocationTap` after the sheet's own close animation lands,
/// reopening it in a loop. Ignore reopen attempts for this long after a close.
const _reopenCooldown = Duration(seconds: 2);

DateTime? _lastClosedAt;

/// BALADY-3764: Navigator Customization opened from a tap on the navigation
/// cursor during guidance / free roam. Shown as a modal ToggleSheet over the
/// map (same pattern as EndTripModal) instead of a full-screen route, so the
/// driver keeps the route context behind the sheet.
Future<void> showCursorsSheet(BuildContext context) async {
  if (_isCursorsSheetOpen) {
    return;
  }
  final lastClosedAt = _lastClosedAt;
  if (lastClosedAt != null && DateTime.now().difference(lastClosedAt) < _reopenCooldown) {
    return;
  }
  _isCursorsSheetOpen = true;
  try {
    await showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      // The route must never pop around the ToggleSheetController (barrier tap /
      // route drag): the controller's AnimationController uses the sheet state's
      // vsync and an instant unmount mid-animation trips the "disposed with an
      // active Ticker" assert. All closes go through controller.close() — see
      // the PopScope in [CursorsSheet].
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (_) => const CursorsSheet(),
    );
  } finally {
    _isCursorsSheetOpen = false;
    _lastClosedAt = DateTime.now();
  }
}

class CursorsSheet extends HookWidget {
  const CursorsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final sheetController = useToggleSheetController(onClose: (_) => Navigator.of(context).pop());
    final colors = context.colors;

    // BALADY-3763: in landscape the sheet is pinned to the leading edge at
    // the standard navi-panel width, like EndTripModal / NaviSheetPanel;
    // full-width rows would push trailing icons across the whole screen.
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    final mediaQueryPadding = MediaQuery.paddingOf(context);
    final panelWidth = NaviSheetPanel.landscapeWidth + mediaQueryPadding.left + mediaQueryPadding.right;

    final sheet = ToggleSheet(
      // Figma 2287-3140: the sheet sits on background/surface2, unlike the
      // full-screen page which uses surface4.
      backgroundColor: colors.backgroundSurface2,
      safeAreaColor: colors.backgroundSurface2,
      dragger: SheetDragger(backgroundColor: colors.backgroundSurface2),
      useSafeArea: false,
      scrollController: sheetController,
      // No barrier dimming: the map behind the panel stays at full
      // brightness so the driver can watch the cursor swap live.
      // Figma 2287-3140: pinned header — "Your cursors" + close button, the
      // subtitle right below; no page-style "Navigator customization" title.
      header: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.yourCursors,
                    style: context.textStyles.h4SemiBold.copyWith(color: colors.foregroundDefault),
                  ),
                ),
                AppCloseButton(onPressed: sheetController.close),
              ],
            ),
            const SizedBox(height: Spacing.$0_5x),
            Text(
              context.l10n.selectNavigatorType,
              style: context.textStyles.bodySmallRegular.copyWith(color: colors.foregroundSoft),
            ),
          ],
        ),
      ),
      content: const [
        // Bottom gutter. The sheet is flush with the screen edge
        // (`useSafeArea: false`), and sheetify only *paints* its safeAreaColor
        // strip — `RenderToggleSheet.performLayout` reserves no height for it,
        // so the last row would otherwise end exactly at the physical bottom
        // with just the Figma 16 under it: glued to the Android nav bar, and
        // under the iOS home indicator.
        //
        // `max(padding.bottom, $3x)` rather than the raw inset, because "has a
        // bottom inset" is not a platform property: Android in 3-button mode
        // (and any pre-15 build that is not edge-to-edge) reports 0 exactly
        // like an iPhone SE, while gesture nav and the iPhone 17 Pro Max home
        // indicator report 24–48. $3x is the same stable inset the navi panels
        // use (see NaviSheetPanel.paddingDelegate).
        SafeAreaPadding(
          left: false,
          top: false,
          right: false,
          minimum: EdgeInsets.only(bottom: Spacing.$3x),
          child: CursorsPageContent(scrollable: false, showHeader: false),
        ),
      ],
    );

    // System back must not pop the route instantly (see showCursorsSheet):
    // divert it into the animated close; onClose then pops for real via
    // Navigator.pop, which PopScope does not intercept.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          sheetController.close();
        }
      },
      child: Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: isLandscape ? Spacing.$3x : 0.0),
          child: SizedBox(
            width: isLandscape ? panelWidth : double.infinity,
            child: sheet,
          ),
        ),
      ),
    );
  }
}
