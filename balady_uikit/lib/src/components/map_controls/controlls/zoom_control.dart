part of '../map_controls.dart';

class ZoomControl extends StatelessWidget {
  final bool zoomInDisabled;
  final bool zoomOutDisabled;
  final void Function(TapUpDetails)? onTapUpZoomIn;
  final void Function(TapDownDetails)? onTapDownZoomIn;
  final void Function(TapUpDetails)? onTapUpZoomOut;
  final void Function(TapDownDetails)? onTapDownZoomOut;

  const ZoomControl({
    required this.zoomInDisabled,
    required this.zoomOutDisabled,
    super.key,
    this.onTapUpZoomIn,
    this.onTapDownZoomOut,
    this.onTapDownZoomIn,
    this.onTapUpZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MapButton(
          onTap: zoomInDisabled ? null : () {},
          onTapUp: onTapUpZoomIn,
          onTapDown: onTapDownZoomIn,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(RadiusBorder.ml),
            topRight: Radius.circular(RadiusBorder.ml),
          ),
          child: const AppIcons(iconData: SystemIcons.zoomPlus),
        ),
        MapButton(
          onTap: zoomInDisabled ? null : () {},
          onTapUp: onTapUpZoomOut,
          onTapDown: onTapDownZoomOut,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(RadiusBorder.ml),
            bottomRight: Radius.circular(RadiusBorder.ml),
          ),
          child: const AppIcons(iconData: SystemIcons.zoomMinus),
        ),
      ],
    );
  }
}
