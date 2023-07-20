import 'dart:async';
import 'dart:math' as math;

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

///Widget showing compass on the map
class CompassControlWidget extends StatelessWidget {
  ///nodoc
  const CompassControlWidget({
    required this.controller,
    super.key,
  });

  final NaviCompassController controller;

  @override
  Widget build(Object context) {
    return StreamBuilder<CompassBearingEvent>(
        stream: controller.events,
        builder: (context, snapshot) {
          final bearing = snapshot.data?.value ?? 0.0;
          final angle = math.pi * (180 - bearing) / 180;
          return bearing != 0
              ? Transform.rotate(
                  angle: angle,
                  child: IconButton(
                    onPressed: () => unawaited(controller.onCompassClicked()),
                    icon: SvgPicture.asset(
                      "packages/dgis_map/assets/svg/compass.svg",
                    ),
                  ),
                )
              : const SizedBox.shrink();
        });
  }
}
