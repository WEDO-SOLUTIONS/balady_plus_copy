import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/data/tifo_activity_log.dart';
import 'package:mapness/features/tifo/data/tifo_api.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:uuid/uuid.dart';

/// US-16 "Earn tokens": a completed Balady+ trip credits TIFO tokens
/// (BRD V2: flat +2 per qualifying trip, minimum 1 km).
///
/// The client only REPORTS the trip — the reward amount, the distance /
/// duration / plausibility validation and the daily cap all live server-side
/// (API v2.4 §4.5), so nothing here can be tuned or gamed from the app.
///
/// Deliberately silent: a rejected trip shows no UI (the BRD asks for silent
/// rejection so abusers can't learn the thresholds) and a failed call is
/// swallowed — token accrual must never interrupt the end of a navigation.
Future<void> reportTifoTripCompleted(WidgetRef ref) async {
  // Read everything BEFORE the first await: the navigation page pops home
  // right after the trip ends, and these must outlive its `ref`.
  final api = ref.read(tifoApiProvider);
  final session = ref.read(tifoSessionProvider.notifier);
  final activityLog = ref.read(tifoActivityLogProvider.notifier);
  try {
    // US-16 prerequisite is "logged in". Checked against the live host session
    // rather than the TIFO profile, which isn't loaded until the player opens
    // the game — otherwise a returning player would lose the reward.
    if (await api.isGuestSession()) {
      return;
    }
    final reward = await api.completeTrip(const Uuid().v4());
    if (!reward.validated) {
      logger.log('[tifo] trip rejected by the backend (validation) — no tokens');
      return;
    }
    if (reward.alreadyRewarded || reward.reward == 0) {
      return;
    }
    final cap = reward.dailyTripCap == null ? '' : '/${reward.dailyTripCap}';
    logger.log(
      '[tifo] trip reward: +${reward.reward} '
      '(today ${reward.tripTokensToday}$cap, balance ${reward.balance})',
    );
    await activityLog.add(
      TifoActivityEntry(type: TifoActivityType.tripCompleted, timestamp: DateTime.now(), tokenDelta: reward.reward),
    );
    // Keep the profile tiles (balance, trips today) honest without waiting for
    // the player to reopen the game.
    await session.refreshProfile();
  } catch (error) {
    logger.log('[tifo] trip reward failed: $error');
  }
}
