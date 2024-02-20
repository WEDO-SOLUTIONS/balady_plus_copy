import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/path_nav/models/path_nav_message.dart';

typedef _State = PathNavManeuverState;

class PathNavMessageWidget extends StatelessWidget {
  final PathNavMessage message;

  const PathNavMessageWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: switch (message.state) {
        _State.error => NonThemeColor.color1,
        _State.reroute => NonThemeColor.color3,
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 4,
          bottom: 10,
          left: 8,
          right: 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 70,
              child: Text(
                message.comment,
                textAlign: TextAlign.end,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .textM
                    .copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            const Padding(
              padding: EdgeInsets.only(top: 6, right: 2, left: 2, bottom: 2),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum PathNavManeuverState {
  error,
  reroute,
}
