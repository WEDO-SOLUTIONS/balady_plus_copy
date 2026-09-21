import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/features/map_tap_handler/map_tap_handler_provider.dart';
import 'package:mapness/pages/navigator_settings/pages/cursors_page/cursors_page_content.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/providers/map/cursors_sheet_visibility_provider.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/shared/ui/safe_area_padding.dart';
import 'package:mapness/widgets/path_nav/ui/navi_sheet_panel.dart';
import 'package:sheetify/sheetify.dart';

/// BALADY-3764/3960: Navigator Customization, opened on a cursor tap during
/// guidance/free roam. Mounted in the page `Stack` like `ParkingBottomSheetPage`
/// — not `showModalBottomSheet`, whose barrier blocked the whole screen.
class CursorsSheet extends HookConsumerWidget {
  const CursorsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final tapDisableOwner = useRef<Object?>(null);

    void releaseTapDisableOwner() {
      final owner = tapDisableOwner.value;
      if (owner == null) {
        return;
      }
      tapDisableOwner.value = null;
      ref.read(mapTapHandlerProvider.notifier).releaseTapDisableOwner(owner);
    }

    final sheetController = useToggleSheetController(
      onClose: (_) {
        // Fires once the close animation has actually landed — only then is
        // it safe to let native onMyLocationTap reach the handler again
        // (BALADY-3923/3960 reopen loop).
        releaseTapDisableOwner();
        ref.read(cursorsSheetVisibilityProvider.notifier).show(value: false);
      },
    );

    final isOpen = ref.watch(cursorsSheetVisibilityProvider);

    ref.listen(cursorsSheetVisibilityProvider, (_, nextIsOpen) {
      if (nextIsOpen) {
        // A tap-and-hold fires more than one native onMyLocationTap
        // (long-press + tap-on-release); acquiring here, synchronously,
        // makes isDisabledTapHandler gate the very next one.
        tapDisableOwner.value ??= ref.read(mapTapHandlerProvider.notifier).acquireTapDisableOwner();
        sheetController.open();
      } else if (!sheetController.isClosed) {
        sheetController.close();
      }
    });

    // Safety net: if the page itself gets torn down while the sheet is open
    // (or still closing), don't leak the tap-disable owner.
    useEffect(() => releaseTapDisableOwner, const []);

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
      // The sheet is now a permanently mounted widget, not a route builder —
      // it must start hidden and take no hit-test space until opened (same
      // as ParkingBottomSheetPage/NaviSheetPanel).
      startConfig: ToggleSheetStart.closed,
      // ToggleSheet's own built-in PopScope defaults shouldPop() to true;
      // unguarded, its Navigator.of(context) now resolves to the *page*
      // Navigator and would pop the whole screen. Only the outer PopScope reacts.
      shouldPop: (_) => false,
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
      content: [
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
        //
        // BALADY-3960: the sheet is mounted for the page's whole lifetime now,
        // so gate the (Riverpod-backed, image-heavy) content on isClosed —
        // it flips true only once the close animation has fully landed.
        ListenableBuilder(
          listenable: sheetController,
          builder: (context, child) => sheetController.isClosed ? const SizedBox.shrink() : child!,
          child: const SafeAreaPadding(
            left: false,
            top: false,
            right: false,
            minimum: EdgeInsets.only(bottom: Spacing.$3x),
            child: CursorsPageContent(scrollable: false, showHeader: false),
          ),
        ),
      ],
    );

    // System back closes the sheet (animated) instead of leaving the screen,
    // but only while it's meant to be open; once a close was already
    // requested, back behaves normally.
    return PopScope(
      canPop: !isOpen,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          ref.read(cursorsSheetVisibilityProvider.notifier).show(value: false);
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
