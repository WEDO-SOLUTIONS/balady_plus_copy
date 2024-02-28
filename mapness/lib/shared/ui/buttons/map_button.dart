
import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:flutter/material.dart';

class MapButton extends StatefulWidget {

  MapButton({
    required this.child,
    this.onTap,
    this.onTapUp,
    this.onTapDown,
    bool? disabled,
    BorderRadius? borderRadius,
    super.key,
  })  : disabled = disabled ?? false,
        borderRadius = borderRadius ?? BorderRadius.circular(10);
  final Widget child;
  final bool disabled;
  final BorderRadius borderRadius;
  final void Function()? onTap;
  final void Function(TapUpDetails)? onTapUp;
  final void Function(TapDownDetails)? onTapDown;

  @override
  State<MapButton> createState() => _MapButtonState();
}

class _MapButtonState extends State<MapButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: widget.onTap,
      onTapUp: (details) {
        setState(() {
          _pressed = false;
        });
        widget.onTapUp?.call(details);
      },
      onTapDown: (details) {
        setState(() {
          _pressed = true;
        });
        widget.onTapDown?.call(details);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 1,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          borderRadius: widget.borderRadius,
          color: _pressed
              ? NonThemeColor.color53
              : Colors.white.withOpacity(0.8),
          child: Container(
            constraints: const BoxConstraints(minWidth: 48),
            height: 48,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.child,
              ],
            ),
          ),
        ),
      ),
    );
}
