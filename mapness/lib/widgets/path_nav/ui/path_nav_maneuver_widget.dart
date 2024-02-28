// ignore_for_file: prefer_expression_function_bodies

import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/entities/path_nav/models/path_nav_maneuver.dart';

class PathNavManeuverWidget extends StatelessWidget {

  const PathNavManeuverWidget({
    required this.maneuver,
    super.key,
  });
  final PathNavManeuver maneuver;

  @override
  Widget build(BuildContext context) => Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 174, minWidth: 136),
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 16,
          left: 8,
          right: 8,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (maneuver.iconPath != null)
                  SvgPicture.asset(
                    maneuver.iconPath!,
                    width: 36,
                    height: 36,
                    colorFilter: const ColorFilter.mode(
                      NonThemeColor.color61,
                      BlendMode.srcATop,
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  maneuver.distance,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  maneuver.unit,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 26,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              maneuver.roadName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).extension<ThemeTextStyles>()!.textS,
            ),
          ],
        ),
      ),
    );
}
