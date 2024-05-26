import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/typedef/app_typedef.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:flutter/material.dart';
import 'package:urbi_utils/urbi_utils.dart';

part 'ab_points_line.dart';
part 'ab_points_point.dart';

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
