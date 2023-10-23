import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/features/landing/widgets/map_control.dart';
import 'package:mapness/features/map/providers/bearing_state.dart';

class CompassControl extends ConsumerWidget {
  const CompassControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bearingState = ref.watch(bearingStateProvider);
    final bearingNotifier = ref.watch(bearingStateProvider.notifier);

    return AnimatedOpacity(
      opacity: bearingState.bearing == 0 ? 0 : 1,
      duration: const Duration(milliseconds: 250),
      child: GestureDetector(
        onTap: bearingNotifier.onCompassTap,
        child: MapControl(
          Transform.rotate(
            angle: bearingState.angle - (150 / 180) * pi,
            child: SvgPicture.asset(
              "assets/icons/svg/ic_control_compass.svg",
              semanticsLabel: 'MinApps Screen',
              package: "mapness",
            ),
          ),
        ),
      ),
    );
  }
}
