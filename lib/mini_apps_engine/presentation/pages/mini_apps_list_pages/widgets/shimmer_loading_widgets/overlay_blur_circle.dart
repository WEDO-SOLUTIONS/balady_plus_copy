import 'dart:ui';

import 'package:flutter/material.dart';

//!
class OverlayBlurCircle extends StatelessWidget {
  const OverlayBlurCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          transform: Matrix4.identity()
            ..translateByDouble(0.0, 0.0, 0.0, 1.0)
            ..rotateZ(-0.08),
          width: 442.09,
          height: 212.29,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: const Alignment(0.50, -0.00),
              end: const Alignment(0.50, 1.00),
              colors: [
                const Color(0XFF36C3B5).withValues(alpha: 0.04),
                const Color(0XFF36C3B5).withValues(alpha: 0.08),
              ],
            ),
            shape: const OvalBorder(),
          ),
        ),
        Container(
          transform: Matrix4.identity()
            ..translateByDouble(0.0, 0.0, 0.0, 1.0)
            ..rotateZ(-0.08),
          width: 442.09,
          height: 212.29 + 100,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(107)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(58.1),
            child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24), child: Container()),
          ),
        ),
      ],
    );
  }
}
