import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/pages/navigator_settings/pages/cursors_page/cursors_page_content.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/widgets/path_nav/ui/navi_sheet_panel.dart';
import 'package:sheetify/sheetify.dart';

final _barrierColorDelegate = ToggleSheetDelegateFunction<Color?>(
  function: (controller) => AppColor.black.withOpacity(0.4 * (1 - controller.interpolation)),
);

/// BALADY-3764: Navigator Customization opened from a tap on the navigation
/// cursor during guidance / free roam. Shown as a modal ToggleSheet over the
/// map (same pattern as EndTripModal) instead of a full-screen route, so the
/// driver keeps the route context behind the sheet.
Future<void> showCursorsSheet(BuildContext context) => showModalBottomSheet<void>(
  backgroundColor: Colors.transparent,
  barrierColor: Colors.transparent,
  isScrollControlled: true,
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
      backgroundColor: colors.backgroundSurface4,
      safeAreaColor: colors.backgroundSurface4,
      dragger: SheetDragger(backgroundColor: colors.backgroundSurface4),
      useSafeArea: false,
      scrollController: sheetController,
      barrierColorDelegate: _barrierColorDelegate,
      header: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(Spacing.$2x),
            child: Center(
              child: Text(
                context.l10n.cursorsNavigatorCustomization,
                style: context.textStyles.h3SemiBold.copyWith(color: colors.foregroundDefault),
              ),
            ),
          ),
          PositionedDirectional(
            end: Spacing.$4x,
            child: AppButton(
              innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$1_5x),
              size: ButtonSize.small,
              primaryIcon: SystemIcons.arrowCornerDownLarge,
              buttonType: ButtonType.secondary,
              buttonColorScheme: ButtonColorScheme.neutral,
              onTap: sheetController.close,
            ),
          ),
        ],
      ),
      content: const [CursorsPageContent(scrollable: false)],
    );

    return Align(
      alignment: AlignmentDirectional.bottomStart,
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: isLandscape ? Spacing.$3x : 0.0),
        child: SizedBox(
          width: isLandscape ? panelWidth : double.infinity,
          child: sheet,
        ),
      ),
    );
  }
}
