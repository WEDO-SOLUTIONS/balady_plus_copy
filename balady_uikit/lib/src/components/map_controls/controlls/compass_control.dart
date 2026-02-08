part of '../map_controls.dart';

class CompassControl extends StatelessWidget {
  final Function()? onTap;
  final double angle;
  final double opacity;

  const CompassControl({
    required this.angle,
    required this.opacity,
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 250),
      child: MapButton(
        borderRadius: BorderRadius.circular(RadiusBorder.xxl),
        onTap: onTap,
        child: Transform.rotate(
          angle: angle - pi / 4,
          child: SvgPicture.asset(
            Assets.icons.svg.mapControls.icControlCompass.path,
            package: packageName,
          ),
        ),
      ),
    );
  }
}
