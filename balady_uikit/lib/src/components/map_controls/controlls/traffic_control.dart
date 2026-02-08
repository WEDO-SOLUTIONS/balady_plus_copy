part of '../map_controls.dart';

class TrafficControl extends StatelessWidget {
  final double opacity;
  final bool isEnabled;
  final BorderRadius? borderRadius;
  final Function()? onTap;

  const TrafficControl({
    required this.opacity,
    required this.isEnabled,
    this.borderRadius,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 250),
      child: MapButton(
        borderRadius: borderRadius,
        onTap: onTap,
        child: SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            isEnabled ? Assets.icons.svg.mapControls.carActive.path : Assets.icons.svg.mapControls.car.path,
            package: packageName,
            colorFilter: onTap == null
                ? ColorFilter.mode(
                    context.colors.foregroundMuted.withOpacity(0.36),
                    BlendMode.srcIn,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
