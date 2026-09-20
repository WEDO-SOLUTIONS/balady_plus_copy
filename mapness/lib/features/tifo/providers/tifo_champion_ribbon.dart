import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mapness/entities/tifo/tifo_champion_ribbon_config.dart';
import 'package:mapness/features/tifo/ui/tifo_champion_confetti.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';

/// Debug override for the champions ribbon: the club to celebrate, or null to
/// follow Remote Config.
///
/// Holds the club's display name rather than an index or an enum, because that
/// is exactly what Remote Config sends and what the ribbon resolves a palette
/// and a translation from — so the override exercises the real code path,
/// including an unrecognised name falling back to the default confetti.
/// Declared by hand rather than through `@riverpod`: it carries one nullable
/// string and needs no generated code.
final tifoChampionRibbonDebugProvider = StateProvider<String?>((ref) => null);

/// The champions ribbon to draw right now, or null when there is none.
///
/// Deliberately independent of `activeCityEventProvider`: that one resolves a
/// single winner out of the code-known occasions by priority, and returns null
/// outright while the TIFO map layer is on. This ribbon answers a different
/// question — the backend says a team won a month — so it may be live at any
/// time, alongside any city event and regardless of the game layer. The banner
/// slot is shared, and the dashboard gives this one precedence.
final tifoChampionRibbonProvider = Provider<TifoChampionRibbonConfig?>((ref) {
  // The override draws a built-in sample rather than whatever Remote Config
  // happens to hold: on an environment with no `tifoChampionRibbon` there is
  // nothing to show, and a switch that does nothing looks broken.
  final override = ref.watch(tifoChampionRibbonDebugProvider);
  if (override != null) {
    return TifoChampionRibbonConfig.debugSample(override, color: TifoChampionConfetti.ribbonColorFor(override));
  }
  final config = ref.watch(dgisEnvironmentProvider.select((env) => env.value?.tifoChampionRibbon));
  if (config == null) {
    return null;
  }
  return config.isVisibleNow ? config : null;
});
