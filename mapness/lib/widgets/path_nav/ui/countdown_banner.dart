import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';

class CountdownBanner extends ConsumerStatefulWidget {
  final String text;
  final VoidCallback onTap;
  final VoidCallback onClose;
  final VoidCallback? onTimeout;
  final Duration duration;
  final IconData? leadingIcon;

  const CountdownBanner({
    required this.text,
    required this.onTap,
    required this.onClose,
    this.onTimeout,
    this.duration = const Duration(seconds: 15),
    this.leadingIcon,
    super.key,
  });

  @override
  ConsumerState<CountdownBanner> createState() => _ParkingBannerState();
}

class _ParkingBannerState extends ConsumerState<CountdownBanner> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(vsync: this, duration: widget.duration);

  @override
  void initState() {
    super.initState();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
        widget.onTimeout?.call();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const boxShadow = [
      BoxShadow(
        offset: Offset(0, 2),
        blurRadius: 10,
        color: Color(0x0D000000),
      ),
    ];

    const borderSizeL = BorderRadius.all(Radius.circular(RadiusBorder.l));
    const borderSizeS = BorderRadius.all(Radius.circular(RadiusBorder.s));

    if (!_animationController.isAnimating && !_animationController.isCompleted) {
      _animationController.forward();
    }

    final textDirection = ref.watch(uiDirectionProvider);
    final isRtl = textDirection == TextDirection.rtl;

    final leadingIcon = widget.leadingIcon;

    return GestureDetector(
      onTap: widget.onTap,
      child: Directionality(
        textDirection: textDirection,
        child: Material(
          type: MaterialType.transparency,
          color: Colors.transparent,
          child: Container(
            height: 56,
            margin: const EdgeInsets.only(
              bottom: Spacing.$3x,
            ),
            decoration: const BoxDecoration(boxShadow: boxShadow),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.colors.neutralOnContainer,
                    borderRadius: borderSizeL,
                  ),
                  padding: const EdgeInsets.all(Spacing.$2x),
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final animationValue = _animationController.value;
                    // Calculating the animation value for corner radius rounding of the container.
                    // The "easeInOut" curve is applied to create a smooth transition effect.
                    // If the animation value (animationValue) exceeds 0.95, a transformation is applied,
                    // which increases the corner radius. Otherwise, the corners remain unchanged.
                    final cornerAnimationValue = Curves.easeInOut.transform(
                      // If the animationValue is greater than 0.95, the formula is applied to increase the corner radius.
                      // The expression (animationValue - 0.95) is transformed into a positive value and multiplied by 20 to scale it.
                      // This allows the corner radius to gradually increase during the last 5% of the animation.
                      // If animationValue is less than 0.95, the corner radius remains unchanged (value 0).
                      (animationValue > 0.95 ? (animationValue - 0.95) * 20 : 0).clamp(0.0, 1.0).toDouble(),
                    );

                    return FractionallySizedBox(
                      widthFactor: animationValue,
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.colors.accentDefault,
                          borderRadius: BorderRadius.only(
                            topLeft: isRtl
                                ? Radius.circular(cornerAnimationValue * RadiusBorder.l)
                                : const Radius.circular(RadiusBorder.l),
                            bottomLeft: isRtl
                                ? Radius.circular(cornerAnimationValue * RadiusBorder.l)
                                : const Radius.circular(RadiusBorder.l),
                            topRight: isRtl
                                ? const Radius.circular(RadiusBorder.l)
                                : Radius.circular(cornerAnimationValue * RadiusBorder.l),
                            bottomRight: isRtl
                                ? const Radius.circular(RadiusBorder.l)
                                : Radius.circular(cornerAnimationValue * RadiusBorder.l),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(Spacing.$2x),
                  child: Row(
                    children: [
                      if (leadingIcon != null) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: context.colors.accentSecondaryOnAccentSecondary,
                            borderRadius: borderSizeS,
                          ),
                          padding: const EdgeInsets.all(Spacing.$2x),
                          child: leadingIcon.icon(color: context.colors.accentDefault),
                        ),
                        Spacing.$3x.widthBox,
                      ],
                      Expanded(
                        child: Text(
                          widget.text,
                          style: context.textStyles.bodyLargeMedium.copyWith(color: context.colors.backgroundSurface1),
                        ),
                      ),
                      AppButton(
                        size: ButtonSize.small,
                        buttonColorScheme: ButtonColorScheme.accent,
                        primaryIcon: SystemIcons.close,
                        iconColor: context.colors.staticWhite,
                        color: Colors.transparent,
                        onTap: widget.onClose,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
