import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PulseIndicator extends HookWidget {
  final Color? color;
  const PulseIndicator({super.key, this.color});

  static const _dotSize = 8.0;
  static const _spreadSize = 24.0;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(seconds: 1),
    )..repeat();

    final indicatorColor = color ?? context.colors.extra01Default;

    return SizedBox(
      width: _spreadSize,
      height: _spreadSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) => Container(
              width: _dotSize,
              height: _dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: indicatorColor,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) => Container(
              width: _dotSize + controller.value * (_spreadSize - _dotSize / 2),
              height: _dotSize + controller.value * (_spreadSize - _dotSize / 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: indicatorColor.withOpacity(
                  1 - controller.value,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
