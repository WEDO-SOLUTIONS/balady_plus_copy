import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/providers/tifo_champion_ribbon.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

/// Picks which champions ribbon the dashboard shows: one of the clubs, or
/// whatever Remote Config holds.
///
/// Each row overrides the ribbon with a sample built from that club's name and
/// nothing else — the name is what Remote Config sends, and what the ribbon
/// resolves both its translation and its confetti palette from, so the rows
/// exercise the real path rather than a shortcut. "Unknown club" is
/// deliberately a name no club matches: it is how the default confetti and the
/// untranslated-name fallback get tested.
class TifoChampionRibbonDebugSwitcher extends ConsumerWidget {
  const TifoChampionRibbonDebugSwitcher({super.key});

  /// Names, not ids, and spelled as the backend spells them.
  static const List<(String?, String, String)> _entries = [
    (null, 'Off (Remote Config)', 'Follow the configured from/to window'),
    ('Black Team', 'Black Team', 'Graphite and silver confetti'),
    ('Blue Team', 'Blue Team', 'Indigo and violet confetti'),
    ('Yellow Team', 'Yellow Team', 'Gold and amber confetti'),
    ('Red Team', 'Red Team', 'Scarlet and coral confetti'),
    ('Sand Team', 'Sand Team', 'Currently Red is palette — spec repeats it'),
    ('Riyadh Rovers', 'Unknown club', 'Falls back to default confetti and the raw name'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(tifoChampionRibbonDebugProvider);
    final fromRemote = ref.watch(dgisEnvironmentProvider.select((env) => env.value?.tifoChampionRibbon));

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DebugSectionHeader(
            icon: Icons.emoji_events_rounded,
            title: 'TIFO champions ribbon',
            subtitle: 'Show a sample ribbon for any club',
            gradient: DebugTheme.gradientTeal,
          ),
          const SizedBox(height: 12),
          for (final (value, label, subtitle) in _entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _TeamRow(
                label: label,
                // The "off" row says what production would actually do right
                // now, so an empty dashboard can be told from a missed window.
                subtitle: value == null ? _remoteSubtitle(fromRemote) : subtitle,
                isActive: value == active,
                onTap: () => ref.read(tifoChampionRibbonDebugProvider.notifier).state = value,
              ),
            ),
        ],
      ),
    );
  }

  String _remoteSubtitle(Object? fromRemote) {
    if (fromRemote == null) {
      return 'Firebase sent no tifoChampionRibbon';
    }
    return 'Follow the configured from/to window';
  }
}

class _TeamRow extends StatelessWidget {
  const _TeamRow({required this.label, required this.subtitle, required this.isActive, required this.onTap});

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
        border: Border.all(color: isActive ? Colors.transparent : Colors.white.withOpacity(0.12)),
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
