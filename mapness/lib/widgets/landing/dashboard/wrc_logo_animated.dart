import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/wrc/wrc.dart';
import 'package:mapness/widgets/landing/dashboard/wrc_logo.dart';
import 'package:sheetify/sheetify.dart';

/// Animated WRC logo that scales and fades based on bottom sheet position.
///
/// The logo animates in two visibility windows:
/// - Opening window: 0.91 → 0.96 (becomes fully invisible at >= 0.96)
/// - Closing window: 0.19 → 0.11 (becomes fully invisible at <= 0.11)
///
/// This creates a smooth fade-in/fade-out effect as the bottom sheet moves.
class WRCLogoAnimated extends ConsumerWidget {
  const WRCLogoAnimated({
    required this.bottomSheetController,
    super.key,
  });

  final MultiStateSheetController<ThreeStateSheet> bottomSheetController;

  // Animation constants
  static const double _openStart = 0.91;
  static const double _openEnd = 0.96; // fully invisible here
  static const double _closeStart = 0.19;
  static const double _closeEnd = 0.11; // fully invisible here
  static const double _eps = 1e-6;
  static const double _baseOffset = 50.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedBuilder(
      animation: bottomSheetController,
      builder: (context, snapshot) {
        final fraction = bottomSheetController.fraction;

        // Compute shrink amount independently for both windows
        final double openT = ((fraction - _openStart) / (_openEnd - _openStart))
            .clamp(0.0, 1.0);
        final double closeT =
            ((_closeStart - fraction) / (_closeStart - _closeEnd))
                .clamp(0.0, 1.0);

        // Take the stronger effect
        final double shrink = max(openT, closeT); // 0.0..1.0
        double scaleValue = 1.0 - shrink; // 1.0..0.0

        // Hard clamp to 0 when beyond full-invisible bounds
        if (fraction >= _openEnd - _eps || fraction <= _closeEnd + _eps) {
          scaleValue = 0.0;
        }

        // Early return if completely invisible
        if (scaleValue <= 0.0) {
          return const SizedBox.shrink();
        }

        final double baseBottom =
            (bottomSheetController.sheetHeight + (_baseOffset * scaleValue))
                .clamp(0.0, double.infinity);

        return Positioned(
          bottom: baseBottom,
          child: Opacity(
            opacity: scaleValue, // fade with scale to avoid artifacts
            child: Transform.scale(
              scale: scaleValue,
              alignment: Alignment.bottomCenter,
              child: WRCLogo(
                onTap: () {
                  ref.read(wRCProvider.notifier).moveCameraToEventArea();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
