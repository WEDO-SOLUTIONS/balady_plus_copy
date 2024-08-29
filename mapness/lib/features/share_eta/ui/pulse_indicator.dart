import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PulseIndicator extends HookWidget {
  final Color color;
  const PulseIndicator({super.key, this.color = Colors.greenAccent});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(seconds: 1),
    )..repeat();

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
                color: color,
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
                color: Colors.greenAccent.withOpacity(
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
