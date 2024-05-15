import 'dart:io';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/pages/path_nav/path_nav_page.dart';
import 'package:mapness/shared/ui/measure_size.dart';

class EtaSheetWrapper extends StatelessWidget {
  final Widget child;
  final bool isExpanded;
  final OnWidgetSizeChange? onSizeChanged;
  final ValueNotifier<int?>? betterRouteDurationProfit;
  final VoidCallback? onBetterRouteAccept;
  final VoidCallback? onBetterRouteReject;
  static const curve = BaseRoadPanel.animationCurve;
  static const duration = BaseRoadPanel.animationDuration;

  const EtaSheetWrapper({
    required this.child,
    required this.isExpanded,
    this.onSizeChanged,
    this.betterRouteDurationProfit,
    this.onBetterRouteAccept,
    this.onBetterRouteReject,
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
      child: Column(
        children: [
          if (betterRouteDurationProfit != null)
            ValueListenableBuilder(
              valueListenable: betterRouteDurationProfit!,
              builder: (context, duration, child) => duration != null
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: Spacing.horizontalPaddingInsideWrapper,
                        right: Spacing.horizontalPaddingInsideWrapper,
                        bottom: Spacing.verticalPaddingInsideCell,
                      ),
                      child: BetterRouteButton(
                        title: 'Found a route ${(duration / 60).floor()} min faster',
                        onTap: onBetterRouteAccept,
                        onCloseTap: onBetterRouteReject,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          Material(
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
        ],
      ),
    );
  }
}
