import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/pages/navigator_settings/pages/cursors_page/cursors_page_content.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/widgets/path_nav/ui/navi_sheet_panel.dart';
import 'package:sheetify/sheetify.dart';

/// BALADY-3764: Navigator Customization opened from a tap on the navigation
/// cursor during guidance / free roam. Shown as a modal ToggleSheet over the
/// map (same pattern as EndTripModal) instead of a full-screen route, so the
/// driver keeps the route context behind the sheet.
Future<void> showCursorsSheet(BuildContext context) => showModalBottomSheet<void>(
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
      content: const [CursorsPageContent(scrollable: false, showHeader: false)],
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
