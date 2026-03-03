part of '../map_controls.dart';

class FollowControl extends StatelessWidget {
  final double opacity;

  final Function()? onTap;

  final Color? iconColor;
  final bool isDriving;

  const FollowControl({
    required this.opacity,
    this.isDriving = false,
    super.key,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isLtr = Directionality.of(context) == TextDirection.ltr;

    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 250),
      child: MapButton(
        onTap: onTap,
        child: (isDriving
                ? TransportIcons.locationDirectionNavigator
                : isLtr
                    ? TransportIcons.locationFullLTR
                    : TransportIcons.locationFullLTR)
            .icon(
          size: 16,
          color: onTap == null
              ? context.colors.foregroundMuted.withOpacity(0.36)
              : iconColor ?? context.colors.foregroundDefault,
        ),
      ),
    );
  }
}
