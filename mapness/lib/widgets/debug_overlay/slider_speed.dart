import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';

class SliderSpeed extends ConsumerStatefulWidget {
  const SliderSpeed({super.key});

  @override
  ConsumerState<SliderSpeed> createState() => _SliderSpeedState();
}

class _SliderSpeedState extends ConsumerState<SliderSpeed> {
  double speed = 70;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(dgisControllerProvider);

    return Slider(
      value: speed,
      min: 5,
      max: 230,
      divisions: 25,
      label: speed.toString(),
      onChanged: (val) {
        setState(() {
          speed = val;

          /// Convert km/h to m/c
          controller.value?.simulationSpeed(speed / 3.6);
        });
      },
    );
  }
}
