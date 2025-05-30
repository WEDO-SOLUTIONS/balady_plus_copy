import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/providers/map/bearing_state.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class CompassControl extends HookConsumerWidget {
  const CompassControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bearingState = ref.watch(bearingStateProvider);
    final bearingNotifier = ref.watch(bearingStateProvider.notifier);

    final animation = useAnimationController(
      duration: Durations.medium1,
      initialValue: bearingState.bearing == 0 ? 0 : 1,
    );

    useEffect(() {
      if (bearingState.bearing == 0) {
        animation.animateTo(0, curve: Curves.easeInOut);
      } else {
        animation.animateTo(1, curve: Curves.easeInOut);
      }
      return null;
    }, [bearingState.bearing]);

    return SizedBox(
      width: 48,
      child: FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          child: ScaleTransition(
            scale: animation,
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
          ),
        ),
      ),
    );
  }
}
