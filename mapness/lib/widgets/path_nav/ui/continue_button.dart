import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
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
          Metrics.logEventAdvanced(
            MetricsConstants.navigationKeys.continueTrip,
            group: MetricsConstants.navigationTag,
            action: MetricAction.tap.toString(),
          );

          ref.read(dgisControllerProvider).value?.startNavigation(
                SpeedRangeZoom(
                  maxSpeedRange: 5,
                  minSpeedRange: 0,
                  routeDistanceMillimeters: 0,
                  styleZoomValue: 16.5,
                ),
              );
        },
      ),
    );
  }
}
