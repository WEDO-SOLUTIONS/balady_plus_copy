import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/providers/map/bearing_state.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class CompassControl extends ConsumerWidget {
  const CompassControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bearingState = ref.watch(bearingStateProvider);
    final bearingNotifier = ref.watch(bearingStateProvider.notifier);

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      child: MapButton(
        borderRadius: BorderRadius.circular(24),
        onTap: bearingNotifier.onCompassTap,
        child: Transform.rotate(
          angle: bearingState.angle - pi - pi / 4,
          child: SvgPicture.asset(
            Assets.icons.svg.icControlCompass.keyName,
            semanticsLabel: 'MinApps Screen',
          ),
        ),
      ),
    );
  }
}
