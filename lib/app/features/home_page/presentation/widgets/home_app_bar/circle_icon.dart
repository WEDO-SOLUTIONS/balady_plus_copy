import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show DrawIconBasedTypeWidget;

class CircleIcon extends StatelessWidget {
  const CircleIcon({
    Key? key,
    required this.icon,
    this.iconSize = 48,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  final Object icon;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? AppColor.blackModern50Light,
        boxShadow: [
          BoxShadow(
            color: AppColor.blackModern900Light.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: DrawIconBasedTypeWidget(
          icon: icon,
          iconColor: iconColor,
        ),
      ),
    );
  }
}
