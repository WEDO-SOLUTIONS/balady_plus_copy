import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/lib/common_functions.dart';

class DirectionText extends StatelessWidget {
  final String title;
  final double bearing;

  const DirectionText({
    required this.title,
    required this.bearing,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(Spacing.$3x),
        child: Align(
          alignment: Alignment(
            cos(CommonFunctions.convertDegreesToRadiansAndShift(bearing)),
            sin(CommonFunctions.convertDegreesToRadiansAndShift(bearing)),
          ),
          child: Text(
            title,
            style: context.textStyle.caption.copyWith(color: Colors.white),
          ),
        ),
      );
}
