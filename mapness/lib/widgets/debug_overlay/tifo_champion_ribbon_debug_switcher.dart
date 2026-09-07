import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/tifo/tifo_champion_ribbon_config.dart';
import 'package:mapness/features/tifo/providers/tifo_champion_ribbon.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

/// Swaps the TIFO champions ribbon between what Remote Config sent and a
/// built-in sample.
///
/// Off, the ribbon behaves exactly as in production: it appears only inside
/// the configured `from`/`to` window, and not at all when Firebase carries no
/// `tifoChampionRibbon`. On, it draws a fixed sample instead, so the ribbon
/// can be reviewed on any environment without waiting for a date or asking
/// the backend for a payload.
///
/// The card names whichever of the two is in effect, so a tester can tell a
/// real payload from the sample at a glance.
class TifoChampionRibbonDebugSwitcher extends ConsumerWidget {
  const TifoChampionRibbonDebugSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forced = ref.watch(tifoChampionRibbonDebugProvider);
    final resolved = ref.watch(tifoChampionRibbonProvider);
    // What production would show right now, so the "off" subtitle can say
    // whether Firebase actually has anything in the window.
    final fromRemote = ref.watch(dgisEnvironmentProvider.select((env) => env.value?.tifoChampionRibbon));

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DebugSectionHeader(
            icon: Icons.emoji_events_rounded,
            title: 'TIFO champions ribbon',
            subtitle: 'Ignore the configured dates and show the ribbon',
            gradient: DebugTheme.gradientTeal,
          ),
          const SizedBox(height: 12),
          SwitchListTile.adaptive(
            value: forced,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Show built-in sample',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
            ),
            subtitle: Text(_subtitle(forced: forced, resolved: resolved, fromRemote: fromRemote),
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
            ),
            onChanged: (value) => ref.read(tifoChampionRibbonDebugProvider.notifier).state = value,
          ),
        ],
      ),
    );
  }

  String _subtitle({
    required bool forced,
    required TifoChampionRibbonConfig? resolved,
    required TifoChampionRibbonConfig? fromRemote,
  }) {
    if (forced) {
      return 'Sample: ${resolved?.teamName ?? '-'} · ${resolved?.month}/${resolved?.year}';
    }
    if (resolved != null) {
      return 'Firebase: ${resolved.teamName} · ${resolved.month}/${resolved.year}';
    }
    if (fromRemote == null || fromRemote.teamName.isEmpty) {
      return 'Firebase sent no tifoChampionRibbon';
    }
    return 'Firebase payload is outside its from/to window';
  }
}
