import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';

class EndTripModal extends HookWidget {
  final VoidCallback? onEndTripPressed;
  final bool isLandscape;

  const EndTripModal({required this.isLandscape, super.key, this.onEndTripPressed});

  @override
  Widget build(BuildContext context) {
    final bottomsheetController = useStatelessBottomsheetController(
      onClose: (_) => Navigator.of(context).pop(),
    );

    return Material(
      type: MaterialType.transparency,
      color: Colors.transparent,
      child: SafeArea(
        child: StatelessBottomSheet(
          safeAreaColor: context.colorsV3.backgroundSurface2,
          scrollController: bottomsheetController,
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
                  child: AppButton(
                    innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
                    size: ButtonSize.small,
                    primaryIcon: SystemIcons.arrowCornerDownLarge,
                    buttonColorScheme: ButtonColorScheme.tertiary,
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
    );
  }
}
