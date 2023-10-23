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
      opacity: trafficState.status == TrafficControlStatus.hidden ? 0 : 1,
      duration: const Duration(milliseconds: 250),
      child: GestureDetector(
        onTap: trafficNotifier.onTrafficTap,
        child: MapControl(
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF7D9CBD),
                    width: 2,
                  ),
                ),
              ),
              Text(
                trafficState.score?.toString() ?? "",
                style: GoogleFonts.notoSansArabic(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
