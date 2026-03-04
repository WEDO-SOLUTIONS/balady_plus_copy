import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/typedef/app_typedef.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:flutter/material.dart';
import 'package:urbi_utils/urbi_utils.dart';

part 'ab_points_line.dart';
part 'ab_points_point.dart';

/// Represents the change in dominance between two AB points,
/// typically used to control visual or logical state transitions.
///
/// Corresponds to the `change` property of a Figma component.
///
/// - `on`: The **first** point is dominant.
/// - `off`: The **last** point is dominant.
/// - `none`: **Both** points are considered equally dominant.
enum ABPointsChange {
  on,
  off,
  none,
}

/// This widget is used to show the A and B points in the path card
/// Here you car give a list of locations and it will show them in a column
/// Also we can give a onTap function to handle the tap on the points (for example, to change route)
///
/// Example:
/// ```dart
/// ABPoints(
///  locations: ['A', 'B'],
/// onTap: () => print('Change route'),
/// )
/// ```
///
/// See also:
/// * [Figma] https://www.figma.com/design/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?m=dev&node-id=7247-46340
class ABPoints extends StatelessWidget {
  final List<String> locations;
  final OnTap? onTap;
  final ABPointsChange change;
  const ABPoints({
    required this.locations,
    super.key,
    this.onTap,
    this.change = ABPointsChange.none,
  });

  @override
  Widget build(BuildContext context) {
    final fromPointColor =
        change == ABPointsChange.off ? context.colors.foregroundSoft : context.colors.foregroundDefault;
    final toPointColor = change == ABPointsChange.on ? context.colors.foregroundSoft : context.colors.foregroundDefault;

    return InkWell(
      onTap: onTap,
      customBorder: smoothBorder(RadiusBorder.m),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: locations
                  .map<Widget>((e) => _Point(isLast: e == locations.last))
                  .insertBetween(const _Line())
                  .toList(),
            ),
          ),
          Spacing.$2x.widthBox,
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: locations
                  .map<Widget>(
                    (e) => Text(
                      e,
                      style: context.textStyles.bodySmallMedium.copyWith(
                        color: e == locations.first ? fromPointColor : toPointColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                  .insertBetween(const SizedBox(height: Spacing.$2x))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
