import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// [BaladyManeuverAlert] is a widget that shows the maneuver alert.
/// The maneuver alert will be show a small card with the maneuver icon, distance, and road name.
/// The data will be passed to the widget using the [BaladyManeuverModel].
///
/// Example:
/// ```dart
/// BaladyManeuverAlert(
///   maneuver: BaladyManeuverModel(
///     distance: '100',
///     unit: 'm',
///     roadName: 'El Nasr Road',
///     instruction: BaladyManeuverInstruction.crossroadSlightlyLeft,
///   ),
/// )
/// ```
///
/// See also:
/// * [Figma]
/// https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=3574%3A43095&mode=design&t=RLpSekxOdSEpOaqf-1
class BaladyManeuverAlert extends StatelessWidget {
  /// The maneuver to be performed on the map.
  final BaladyManeuverModel maneuver;

  /// Constructor
  const BaladyManeuverAlert({
    required this.maneuver,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final maneuverIconPath = maneuver.instruction?.iconPath;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(RadiusBorder.xl),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 176, minWidth: 136),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusBorder.xl),
          color: context.colors.onmapSurfaceOnMap,
          boxShadow: Shadows.m,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (maneuverIconPath != null)
                  SvgPicture.asset(
                    maneuverIconPath,
                    package: packageName,
                    width: 36,
                    height: 36,
                  ),
                if (maneuverIconPath != null) const SizedBox(width: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      maneuver.distance,
                      style: context.textStyles.h1SemiBold,
                    ),
                    const SizedBox(width: 2),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0, top: 10.0),
                      child: Text(maneuver.unit, style: context.textStyles.bodySmallSemiBold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              maneuver.roadName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.bodySmallMedium.copyWith(
                color: context.colors.foregroundDefault,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
