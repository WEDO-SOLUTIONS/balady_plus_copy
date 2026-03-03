part of 'package:balady_uikit/src/components/map_controls/map_controls.dart';

class MapButton extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final void Function()? onTap;
  final void Function(TapUpDetails)? onTapUp;
  final void Function(TapDownDetails)? onTapDown;

  MapButton({
    required this.child,
    this.onTap,
    this.onTapUp,
    this.onTapDown,
    BorderRadius? borderRadius,
    super.key,
  }) : borderRadius = borderRadius ?? BorderRadius.circular(RadiusBorder.ml);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: Shadows.s,
      ),
      child: Material(
        borderRadius: borderRadius,
        color: context.colors.backgroundSurface1,
        child: GestureDetector(
          onTapUp: onTapUp,
          onTapDown: onTapDown,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 48,
                maxHeight: 48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
