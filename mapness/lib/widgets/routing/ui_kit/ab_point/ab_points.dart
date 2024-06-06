import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/typedef/app_typedef.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:flutter/material.dart';
import 'package:urbi_utils/urbi_utils.dart';

part 'ab_points_line.dart';
part 'ab_points_point.dart';

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
  const ABPoints({required this.locations, super.key, this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTap,
      customBorder: smoothBorder(8),
      splashColor: context.color.surfaceOverlayPressed,
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
          Spacing.horizontalGapBetweenChips.widthBox,
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: locations
                  .map<Widget>(
                    (e) => Text(
                      e,
                      style: context.textStyle.footNote,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                  .insertBetween(const SizedBox(height: 4))
                  .toList(),
            ),
          ),
        ],
      ));
}
