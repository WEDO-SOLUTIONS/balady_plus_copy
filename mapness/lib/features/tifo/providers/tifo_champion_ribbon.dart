import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mapness/entities/tifo/tifo_champion_ribbon_config.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';

/// Debug override for the champions ribbon: forces it on screen whatever the
/// configured window says, so QA does not have to wait for a date. Declared by
/// hand rather than through `@riverpod` because it holds nothing but a bool
/// and needs no generated code.
final tifoChampionRibbonDebugProvider = StateProvider<bool>((ref) => false);

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
  // nothing to show, and a toggle that does nothing looks broken.
  if (ref.watch(tifoChampionRibbonDebugProvider)) {
    return TifoChampionRibbonConfig.debugSample();
  }
  final config = ref.watch(dgisEnvironmentProvider.select((env) => env.value?.tifoChampionRibbon));
  if (config == null) {
    return null;
  }
  return config.isVisibleNow ? config : null;
});
