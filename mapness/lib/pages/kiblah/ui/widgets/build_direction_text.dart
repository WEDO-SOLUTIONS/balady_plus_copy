import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapness/pages/kiblah/ui/kiblah_compass.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class BuildDirectionText extends StatelessWidget {
  final String title;
  final double bearing;

  const BuildDirectionText({
    required this.title,
    required this.bearing,
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      Padding(padding: EdgeInsets.all(12),
        child: Align(
        alignment: Alignment(
            cos(KiblahCompass.rad(bearing)),
            sin(KiblahCompass.rad(bearing)),
          ),
          child: Text(
            title,
            style: context.textStyle.caption.copyWith(color: Colors.white),
          ),
      ),);
}
