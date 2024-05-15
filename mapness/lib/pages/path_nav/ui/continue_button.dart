import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_continue_trip.dart';

class ContinueButton extends ConsumerWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eta = ref.watch(pathNavEtaProvider);
    return Align(
      alignment: Alignment.bottomCenter,
      child: PathNavContinueTrip(
        eta: eta,
        onPressed: () {
          ref.read(urbiMetricsProvider.notifier).logEvent(
                'Routes/Navigator/Continue trip => Tap',
              );
          ref.read(dgisControllerProvider).value?.startNavigation();
        },
      ),
    );
  }
}
