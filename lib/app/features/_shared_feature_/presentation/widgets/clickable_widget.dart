import 'package:flutter/material.dart';

class ClickableWidget extends StatelessWidget {
  final Color? effectColor;
  final double? radius;
  final Widget child;
  // It can be null to disable clicking
  final VoidCallback? onPressed;
  const ClickableWidget({super.key, this.effectColor, this.radius, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: _borderRadius,
      child: InkWell(
        splashColor: effectColor,
        highlightColor: Colors.transparent,
        customBorder: RoundedRectangleBorder(borderRadius: _borderRadius),
        onTap: onPressed,
        child: child,
      ),
    );
  }

  BorderRadiusGeometry get _borderRadius => radius != null ? BorderRadius.circular(radius!) : BorderRadius.zero;
}
