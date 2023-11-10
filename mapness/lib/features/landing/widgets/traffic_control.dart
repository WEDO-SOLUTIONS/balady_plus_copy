import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/map/providers/traffic_state.dart';

import 'map_control.dart';

class TrafficControl extends ConsumerWidget {
  const TrafficControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trafficState = ref.watch(trafficStateProvider);
    final trafficNotifier = ref.watch(trafficStateProvider.notifier);

    return AnimatedOpacity(
      opacity: trafficState.status == TrafficControlStatus.hidden ? 1 : 1,
      duration: const Duration(milliseconds: 250),
      child: MapControl(
        onTap: trafficNotifier.onTrafficTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFFFB814),
                  width: 2,
                ),
              ),
            ),
            Text(
              "5", // trafficState.score?.toString() ?? "5",
              style: GoogleFonts.inter(
                fontSize: 16,
                height: 20 / 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
