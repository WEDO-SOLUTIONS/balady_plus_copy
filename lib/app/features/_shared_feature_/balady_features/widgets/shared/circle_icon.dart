import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  const CircleIcon({
    super.key,
    required this.icon,
    this.circleSize = 48,
    this.backgroundColor,
    this.iconColor,
    this.iconSize = 18,
    this.showShadow = true,
  });

  final Object icon;
  final double circleSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final double iconSize;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        boxShadow: showShadow == true
            ? [
                BoxShadow(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Center(
        child: DrawIconBasedTypeWidget(icon: icon, iconColor: iconColor, iconSize: iconSize),
      ),
    );
  }
}
