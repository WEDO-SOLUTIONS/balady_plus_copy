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

    void cancel() {
      onCancel();
      context.router.pop();
    }

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
                onTap: () {
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
                    _CancelButton(onTap: cancel),
                    _AnimatedClipWidget(
                      onAnimationCompleted: cancel,
                      child: _CancelButton(
                        bgColor: context.colors.neutralOnContainer,
                        textColor: context.colors.accentSecondaryOnAccentSecondary,
                        onTap: cancel,
                      ),
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

class _CancelButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? bgColor;
  final Color? textColor;

  const _CancelButton({this.onTap, this.bgColor, this.textColor});

  @override
  Widget build(BuildContext context) => AppButton(
    buttonColorScheme: ButtonColorScheme.accentSecondary,
    size: ButtonSize.large,
    color: bgColor,
    buttonType: ButtonType.secondary,
    textColor: textColor,
    primaryLabel: context.l10n.cancel,
    onTap: onTap,
  );
}

class _AnimatedClipWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onAnimationCompleted;

  const _AnimatedClipWidget({required this.child, this.onAnimationCompleted});

  @override
  _AnimatedClipWidgetState createState() => _AnimatedClipWidgetState();
}

class _AnimatedClipWidgetState extends State<_AnimatedClipWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _controller.forward().then((_) => widget.onAnimationCompleted?.call());

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _animation,
    builder: (context, child) => ClipRRect(
      clipper: _Clipper(_animation.value),
      borderRadius: const BorderRadius.horizontal(left: Radius.circular(Spacing.$2_5x)),
      child: child,
    ),
    child: widget.child,
  );
}

// Animates the clipping rectangle width from 0 to full size
class _Clipper extends CustomClipper<RRect> {
  final double progress;

  _Clipper(this.progress);

  @override
  RRect getClip(Size size) {
    if (size.width == 0 || size.height == 0) {
      return RRect.zero;
    }
    return RRect.fromRectAndRadius(
      Rect.fromPoints(Offset.zero, Offset(size.width * progress, size.height)),
      Radius.zero,
    );
  }

  @override
  bool shouldReclip(covariant _Clipper oldClipper) => oldClipper.progress != progress;
}
