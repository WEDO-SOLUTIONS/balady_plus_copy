import 'dart:io';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/ui/measure_size.dart';

class EtaSheetWrapper extends StatelessWidget {
  final Widget child;
  final bool isExpanded;
  final VoidCallback onBgTap;
  final OnWidgetSizeChange? onSizeChanged;
  static const curve = BaseRoadPanel.animationCurve;
  static const duration = BaseRoadPanel.animationDuration;

  const EtaSheetWrapper({
    required this.child,
    required this.isExpanded,
    required this.onBgTap,
    this.onSizeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    double bottomPadding = media.padding.bottom;
    if (Platform.isAndroid) {
      bottomPadding += Spacing.verticalBaseToBottomSafezone;
    }
    return MeasureSize(
      onChange: (size) {
        // This method called only if we want to rebuild (expand) our widget
        onSizeChanged?.call(size);
      },
      child: Material(
        color: isExpanded ? Colors.white : Colors.transparent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: AnimatedPadding(
          padding: EdgeInsets.only(
            left: isExpanded ? 0 : Spacing.horizontalPaddingInsideWrapper,
            right: isExpanded ? 0 : Spacing.horizontalPaddingInsideWrapper,
            bottom: bottomPadding,
          ),
          duration: duration,
          curve: curve,
          child: child,
        ),
      ),
    );
  }
}
