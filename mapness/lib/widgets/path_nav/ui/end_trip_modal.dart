import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';
import 'package:mapness/widgets/path_nav/ui/navi_sheet_panel.dart';

class EndTripModal extends HookWidget {
  final VoidCallback? onEndTripPressed;

  const EndTripModal({super.key, this.onEndTripPressed});

  @override
  Widget build(BuildContext context) {
    final bottomsheetController = useStatelessBottomsheetController(
      onClose: (_) => Navigator.of(context).pop(),
    );

    final viewPaddingOf = MediaQuery.viewPaddingOf(context);
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: viewPaddingOf.copyWith(left: viewPaddingOf.left + (isLandscape ? Spacing.$4x : 0.0)),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: isLandscape ? NaviSheetPanel.landscapeWidth - Spacing.$4x * 2 : double.infinity),
          child: StatelessBottomSheet(
            safeAreaColor: context.colorsV3.backgroundSurface1,
            scrollController: bottomsheetController,
            backgroundColorDelegate: StatelessSheetDelegateFunction<Color?>(
              function: (controller) => AppColor.black.withOpacity(0.4 * (1 - controller.interpolation)),
            ),
            content: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(
                      Spacing.$2x,
                    ),
                    child: Center(child: Text(context.l10n.endTrip, style: context.textStyleV3.h3SemiBold)),
                  ),
                  PositionedDirectional(
                    end: Spacing.$4x,
                    child: BaladyAppButton(
                      innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$1_5x),
                      size: BaladyButtonSize.small,
                      primaryIcon: SystemIcons.arrowCornerDownLarge,
                      buttonType: BaladyButtonType.secondary,
                      buttonColorScheme: BaladyButtonColorScheme.neutral,
                      onTap: Navigator.of(context).pop,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.$4x),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                child: BaladyAppButton(
                  primaryLabel: context.l10n.yesEnd,
                  size: BaladyButtonSize.large,
                  buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
                  onTap: onEndTripPressed,
                ),
              ),
              const SizedBox(height: Spacing.$3x),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                child: BaladyAppButton(
                  primaryLabel: context.l10n.cancel,
                  size: BaladyButtonSize.large,
                  buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
                  buttonType: BaladyButtonType.secondary,
                  onTap: Navigator.of(context).pop,
                ),
              ),
              const SizedBox(height: Spacing.$3x),
            ],
          ),
        ),
      ),
    );
  }
}
