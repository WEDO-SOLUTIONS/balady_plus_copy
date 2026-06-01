import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/free_roam/simulation_speed_controller.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

class SliderSpeed extends ConsumerWidget {
  const SliderSpeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speed = ref.watch(simulationSpeedProvider);

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DebugSectionHeader(
            icon: Icons.speed_rounded,
            title: 'Simulation Speed',
            subtitle: 'Adjust navigation simulation speed',
            gradient: DebugTheme.gradientAmber,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: DebugTheme.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Speed',
                      style: context.textStyles.captionSmallRegular.copyWith(
                        color: DebugTheme.textMuted,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: DebugTheme.gradientAmber,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${speed.toInt()} km/h',
                        style: context.textStyles.captionSmallMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: DebugTheme.warning,
                    inactiveTrackColor: DebugTheme.border,
                    thumbColor: Colors.white,
                    overlayColor: DebugTheme.warning.withOpacity(0.2),
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                      elevation: 4,
                    ),
                  ),
                  child: Slider(
                    value: speed,
                    min: 5,
                    max: 230,
                    divisions: 45,
                    onChanged: (val) => ref.read(simulationSpeedProvider.notifier).setKmh(val),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '5 km/h',
                      style: context.textStyles.captionSmallRegular.copyWith(
                        color: DebugTheme.textMuted,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '230 km/h',
                      style: context.textStyles.captionSmallRegular.copyWith(
                        color: DebugTheme.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
