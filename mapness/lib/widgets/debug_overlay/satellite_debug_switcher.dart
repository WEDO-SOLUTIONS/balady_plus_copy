import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/satellite/providers/satellite_debug.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

class SatelliteDebugSwitcher extends ConsumerWidget {
  const SatelliteDebugSwitcher({super.key});

  static const _entries = <(SatelliteDebugSource, String, String)>[
    (SatelliteDebugSource.frc, 'FRC (prod)', 'satellite_config from Firebase Remote Config'),
    (SatelliteDebugSource.satproxy, 'Satproxy (stg)', 'urbi-lifestyle-stg satproxy'),
    (SatelliteDebugSource.wmtsEsri, 'ESRI WMTS', 'arcgisonline World_Imagery, JPEG'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(satelliteDebugOverrideProvider);
    final notifier = ref.read(satelliteDebugOverrideProvider.notifier);

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DebugSectionHeader(
            icon: Icons.satellite_alt_rounded,
            title: 'Satellite source',
            subtitle: 'Override the satellite tile source',
            gradient: DebugTheme.gradientTeal,
          ),
          const SizedBox(height: 12),
          for (final (source, label, subtitle) in _entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _SourceRow(
                label: label,
                subtitle: subtitle,
                isActive: source == active,
                onTap: () => notifier.select(source),
              ),
            ),
        ],
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.label, required this.subtitle, required this.isActive, required this.onTap});

  final String label;
  final String subtitle;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: isActive ? DebugTheme.gradientTeal : null,
        color: isActive ? null : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? Colors.transparent : Colors.white.withOpacity(0.12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
            color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isActive ? Colors.white.withOpacity(0.85) : Colors.white.withOpacity(0.45),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
