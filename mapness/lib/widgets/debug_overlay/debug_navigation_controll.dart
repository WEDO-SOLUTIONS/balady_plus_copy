import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/constants/navigation_constants.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class DebugNavigationControll extends ConsumerWidget {
  const DebugNavigationControll({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(dgisControllerProvider);

    return LabeledElevatedButton(
      onPressed: () => controller.value?.startNavigationSimulation(
        NavigationConstants.navigationSpeedRangeZooms,
      ),
      label: 'start navigation simulation',
    );
  }
}
