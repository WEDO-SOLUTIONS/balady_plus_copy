import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor;
import '../../../../_shared_feature_/shared_feature_exports.dart' show DrawIconBasedTypeWidget;

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
        color: backgroundColor ?? AppColor.blackModern50Light,
        boxShadow: showShadow == true
            ? [
                BoxShadow(
                  color: AppColor.blackModern900Light.withValues(alpha: 0.1),
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
