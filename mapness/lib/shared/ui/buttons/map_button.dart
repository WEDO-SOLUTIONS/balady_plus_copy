import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class MapButton extends StatefulWidget {
  static const double defaultSize = 48;
  final double height;

  MapButton({
    required this.child,
    this.onTap,
    this.onTapUp,
    this.onTapDown,
    this.height = defaultSize,
    bool? disabled,
    BorderRadius? borderRadius,
    /// When set, screen readers announce this label for the map control (icon stays decorative).
    this.semanticsLabel,
    super.key,
  }) : disabled = disabled ?? false,
       borderRadius = borderRadius ?? BorderRadius.circular(10);
  final Widget child;
  final bool disabled;
  final BorderRadius borderRadius;
  final void Function()? onTap;
  final void Function(TapUpDetails)? onTapUp;
  final void Function(TapDownDetails)? onTapDown;
  final String? semanticsLabel;

  @override
  State<MapButton> createState() => _MapButtonState();
}

class _MapButtonState extends State<MapButton> {
  @override
  Widget build(BuildContext context) {
    final columnChild = widget.semanticsLabel != null
        ? ExcludeSemantics(child: widget.child)
        : widget.child;

    final inner = Container(
      constraints: const BoxConstraints(minWidth: MapButton.defaultSize),
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 1),
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Material(
        borderRadius: widget.borderRadius,
        color: context.colors.onMapSurfaceOnMap,
        child: InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: widget.borderRadius),
          onTap: widget.onTap,
          onTapUp: (details) {
            widget.onTapUp?.call(details);
          },
          onTapDown: (details) {
            widget.onTapDown?.call(details);
          },
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [columnChild]),
        ),
      ),
    );

    if (widget.semanticsLabel != null) {
      return Semantics(
        button: true,
        label: widget.semanticsLabel,
        child: inner,
      );
    }

    return inner;
  }
}
