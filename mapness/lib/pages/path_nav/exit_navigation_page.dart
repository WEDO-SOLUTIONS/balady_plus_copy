import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class ExitNavigationPage extends HookConsumerWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ExitNavigationPage({required this.onConfirm, required this.onCancel, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useToggleSheetController(
      onClose: (controller) {
        context.router.pop();
      },
    );

    return ToggleSheet(
      scrollController: scrollController,
      backgroundColor: context.colors.backgroundSurface4,
      safeAreaColor: context.colors.backgroundSurface4,
      dragger: SheetDragger(backgroundColor: context.colors.backgroundSurface4),
      outside: GestureDetector(onTap: context.router.pop),
      content: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(Spacing.$3x),
              child: Center(
                child: Text(
                  context.l10n.exitCurrentNavigation,
                  style: context.textStyles.h3SemiBold.copyWith(color: context.colors.foregroundDefault),
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
                onTap: Navigator.of(context).pop,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.$2x),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$3x),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                buttonColorScheme: ButtonColorScheme.accentSecondary,
                size: ButtonSize.large,
                primaryLabel: context.l10n.yes,
                onTap: () async {
                  onConfirm();
                  context.router.pop();
                },
              ),
              const SizedBox(height: Spacing.$3x),
              SizedBox(
                height: 48,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: Spacing.$3x,
                      bottom: Spacing.$3x,
                      left: Spacing.$4x,
                      child: SizedBox.square(
                        dimension: 24,
                        child: CountdownProgress(
                          animationDuration: const Duration(seconds: 4),
                          onComplete: () {
                            onCancel();
                            context.router.pop();
                          },
                        ),
                      ),
                    ),
                    AppButton(
                      buttonColorScheme: ButtonColorScheme.accentSecondary,
                      size: ButtonSize.large,
                      buttonType: ButtonType.secondary,
                      primaryLabel: context.l10n.cancel,
                      onTap: () async {
                        onCancel();
                        context.router.pop();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CountdownProgress extends StatelessWidget {
  final Duration animationDuration;
  final VoidCallback? onComplete;

  const CountdownProgress({required this.animationDuration, this.onComplete, super.key});

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween<double>(begin: 0.0, end: 1),
    duration: animationDuration,
    onEnd: onComplete,
    builder: (context, value, child) => Stack(
      alignment: AlignmentGeometry.center,
      children: [
        Text(
          (animationDuration - animationDuration * value + const Duration(seconds: 1)).inSeconds.toString(),
          style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.accentSecondaryDefault),
        ),
        CircularProgressIndicator(
          value: value,
          strokeWidth: 2,
          backgroundColor: Colors.transparent,
          color: context.colors.accentSecondaryDefault,
        ),
      ],
    ),
  );
}
