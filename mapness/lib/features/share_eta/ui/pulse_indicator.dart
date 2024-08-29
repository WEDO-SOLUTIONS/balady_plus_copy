import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PulseIndicator extends HookWidget {
  final Color? color;
  const PulseIndicator({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(seconds: 1),
    )..repeat();

    final indicatorColor = color ?? context.colorsV2.extra01Default;

    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) => Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: indicatorColor,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) => Container(
              width: 8 + controller.value * 20,
              height: 8 + controller.value * 20,
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
