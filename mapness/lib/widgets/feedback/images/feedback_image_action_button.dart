import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class ImageActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final double size;
  final double iconSize;

  const ImageActionButton({
    required this.onTap,
    required this.icon,
    super.key,
    this.size = 16,
    this.iconSize = 14,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.black.withOpacity(0.6),
          ),
          child: Center(
            child: Icon(
              icon,
              color: context.colorsV2.backgroundSurface1,
              size: iconSize,
            ),
          ),
        ),
      );
}
