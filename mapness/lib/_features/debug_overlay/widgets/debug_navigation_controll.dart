import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class DebugNavigationControll extends ConsumerWidget {
  const DebugNavigationControll({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(dgisControllerProvider);

    return LabeledElevatedButton(
      onPressed: () => controller.value?.startNavigationSimulation(
        SpeedRangeZoom(
          maxSpeedRange: 5,
          minSpeedRange: 0,
          routeDistanceMillimeters: 0,
          styleZoomValue: 16.5,
        ),
      ),
      label: 'start navigation simulation',
    );
  }
}
