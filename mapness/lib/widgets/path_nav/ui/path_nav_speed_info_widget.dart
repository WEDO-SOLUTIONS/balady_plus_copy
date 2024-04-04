import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mapness/entities/path_nav/models/path_nav_speed_info.dart';
import 'package:mapness/widgets/path_nav/lib/navi_direction_icon_extension.dart';

class PathNavSpeedInfoWidget extends StatelessWidget {

  const PathNavSpeedInfoWidget({
    required this.info, super.key,
  });
  final PathNavSpeedInfo info;

  @override
  Widget build(BuildContext context) {
    const red = NonThemeColor.color59;
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 94,
        height: 94,
        child: Stack(
          children: [
            /// speed
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                width: 64,
                height: 64,
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                  ),
                  // elevation: 2.0,
                  child: Center(
                    child: Baseline(
                      baselineType: TextBaseline.alphabetic,
                      baseline: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .accent
                          .fontSize!,
                      child: Text(
                        '${info.speed}',
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .accent
                            .copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// speed limit
            Positioned(
              top: 0,
              right: 0,
              child: SizedBox(
                width: 54,
                height: 54,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: red,
                      width: 4,
                    ),
                    color: info.speedExceed ? red : Colors.white,
                  ),
                  child: Center(
                    child: Baseline(
                      baselineType: TextBaseline.alphabetic,
                      baseline: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .heading1
                          .fontSize!,
                      child: Text(
                        "${info.speedLimit ?? '--'}",
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .heading1
                            .copyWith(
                              color: info.speedExceed
                                  ? Colors.white
                                  : Colors.black,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// camera
            if (info.direction != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(
                  info.direction!.iconPath,
                  width: 24,
                  height: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
