import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';

class EtaSheetWrapper extends StatelessWidget {
  final Widget child;
  final bool isExpanded;
  final VoidCallback onBgTap;
  static const curve = BaseRoadPanel.animationCurve;
  static const duration = BaseRoadPanel.animationDuration;

  const EtaSheetWrapper({
    required this.child,
    required this.isExpanded,
    required this.onBgTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        IgnorePointer(
          ignoring: !isExpanded,
          child: GestureDetector(
            onTap: isExpanded ? onBgTap : null,
            child: AnimatedContainer(
              duration: duration,
              height: media.size.height,
              width: media.size.width,
              curve: curve,
              color: Colors.black.withOpacity(isExpanded ? 0.7 : 0.0),
            ),
          ),
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
              bottom:
                  media.padding.bottom + Spacing.verticalBaseToBottomSafezone,
            ),
            duration: duration,
            curve: curve,
            child: child,
          ),
        ),
      ],
    );
  }
}
