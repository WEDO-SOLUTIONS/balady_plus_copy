import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:flutter/material.dart';

class CustomMiniAppsIconButton extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? iconColor;
  final IconData? icon;
  const CustomMiniAppsIconButton({super.key, this.height, this.width, this.backgroundColor, this.iconColor, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 10,
      width: width ?? 10,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.onSurface.withAlpha(10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(context.isRTL ? icon ?? Icons.east : icon ?? Icons.west),
          color: iconColor ?? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
