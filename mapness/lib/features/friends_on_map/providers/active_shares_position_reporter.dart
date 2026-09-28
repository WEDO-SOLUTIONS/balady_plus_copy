import 'dart:async';

import 'package:mapness/features/friends_on_map/models/active_share.dart';
import 'package:mapness/features/friends_on_map/models/share_mode.dart';
import 'package:mapness/features/friends_on_map/providers/active_shares_controller.dart';
import 'package:mapness/features/friends_on_map/providers/active_shares_repository.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_shares_position_reporter.g.dart';

// S-19: between friends_on_map's own 10-15s friend-position poll and
// friends_on_map_position_reporter.dart's 30s report interval — BRD only
// needs "current position", not sub-second smoothness (see this file's
// AGENTS.md S-19 slice notes for the full reasoning).
const Duration _kReportInterval = Duration(seconds: 8);

// keepAlive: same rationale as friends_on_map_position_reporter.dart — must
// keep pushing regardless of which screen is focused, for as long as any
// share is active. Watched from pages/map/map_page.dart's always-mounted
// cascade.
@Riverpod(keepAlive: true)
class ActiveSharesPositionReporter extends _$ActiveSharesPositionReporter {
  Timer? _timer;

  @override
  void build() {
    final shares = ref.watch(activeSharesControllerProvider).value ?? const <ActiveShare>[];

    // Same cancel-then-recreate-in-build guard as
    // friends_on_map_position_reporter.dart, so a rebuild (e.g. a share
    // starting/stopping) never leaves two timers running.
    _timer?.cancel();
    _timer = null;
    ref.onDispose(() => _timer?.cancel());

    if (shares.isEmpty) {
      return;
    }
    // Keep pathNavEtaProvider's native event subscription alive for as long
    // as an eta-mode share is active, regardless of whether PathNavPage's
    // own widgets are currently mounted/watching it (ref.listen creates the
    // keep-alive edge without the rebuild-on-every-tick cost ref.watch would
    // have here). Without this, opening the share link itself — which
    // navigates away from PathNavRoute — tore down pathNavEtaProvider even
    // though native navigation kept running, permanently dropping the eta
    // field from every subsequent push. See friends_on_map/AGENTS.md's S-19
    // notes.
    if (shares.any((share) => share.mode == ShareMode.eta)) {
      ref.listen(pathNavEtaProvider, (_, __) {});
    }
    _timer = Timer.periodic(_kReportInterval, (_) => unawaited(_reportAll(shares)));
    // Report immediately rather than waiting for the first tick — same
    // reasoning as friends_on_map_position_reporter.dart: a freshly-created
    // share shouldn't show a recipient nothing for up to a full interval.
    unawaited(_reportAll(shares));
  }

  Future<void> _reportAll(List<ActiveShare> shares) async {
    final position = ref.read(locationProvider);
    if (position == null) {
      return;
    }
    for (final share in shares) {
      if (!ref.mounted) {
        return;
      }
      // Kept alive independent of PathNavPage's own mount state by the
      // ref.listen guard in build() above, for as long as this share stays
      // in the shares list. Only reverts to null once navigation truly ends
      // AND the share itself is stopped/expired (build() re-runs without any
      // eta-mode share left, dropping the ref.listen) — until then the
      // recipient keeps a live, not just last-known, estimate.
      final eta = share.mode == ShareMode.eta ? ref.read(pathNavEtaProvider) : null;
      try {
        await ref
            .read(activeSharesRepositoryProvider)
            .reportPosition(
              share.id,
              lat: position.latitude,
              lon: position.longitude,
              etaArrivalAt: eta == null ? null : DateTime.now().toUtc().add(Duration(seconds: eta.durationInSeconds)),
              etaDistanceMeters: eta?.rawDistance,
            );
      } catch (ex, stackTrace) {
        // Isolated per-share: one failing push (e.g. a 404 for a share that
        // just expired) must not abort the loop and silently skip every
        // share after it — same reasoning as friend_markers.dart's
        // per-friend try/catch in _refreshLabels().
        logger.log('Error reporting position for share ${share.id}: $ex\n$stackTrace');
      }
      if (!ref.mounted) {
        return;
      }
    }
  }
}
