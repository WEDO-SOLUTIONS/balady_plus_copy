import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/traffic_state.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class TrafficControl extends ConsumerWidget {
  const TrafficControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trafficState = ref.watch(trafficStateProvider);
    final trafficNotifier = ref.watch(trafficStateProvider.notifier);
    final isEnabled = trafficState.status == TrafficControlStatus.enabled;

    return AnimatedOpacity(
      opacity: trafficState.status == TrafficControlStatus.hidden ? 0 : 1,
      duration: const Duration(milliseconds: 250),
      child: MapButton(
        onTap: () {
          ref
              .read(urbiMetricsProvider.notifier)
              .logEvent('Explore/Traffic light button => Tap');
          trafficNotifier.onTrafficTap();
        },
        child: SizedBox(
          width: 28,
          height: 28,
          child: SvgPicture.asset(
            isEnabled
                ? 'assets/icons/svg/ic_traffic_active.svg'
                : 'assets/icons/svg/ic_traffic.svg',
            package: PackageConfig.packageName,
            width: 28,
            height: 28,
          ),
        ),
      ),
    );
  }
}
