import 'dart:async';

import 'package:mapness/features/friends_on_map/models/friends_on_map_activation_status.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_activation.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_position_repository.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_on_map_position_reporter.g.dart';

// TODO(BE-213): 30s is a placeholder single interval, not the BRD's N-01–N-04
// adaptive foreground/background/battery intervals (five seconds in the
// foreground) — see the standing scope decision in AGENTS.md.
const Duration _kReportInterval = Duration(seconds: 30);

// keepAlive: this provider's whole job is to run a Timer for as long as
// activation status says it should, independent of whether any widget is
// watching it. An auto-dispose provider would stop reporting the moment the
// last widget watching it unmounted (e.g. leaving the Friends on Map page),
// which is exactly the behavior R-13 forbids — reporting must continue
// while the feature is active, not only while its screen is open.
@Riverpod(keepAlive: true)
class FriendsOnMapPositionReporter extends _$FriendsOnMapPositionReporter {
  Timer? _timer;

  @override
  void build() {
    final status = ref.watch(friendsOnMapActivationProvider).value;
    final reporting =
        status == FriendsOnMapActivationStatus.activeForegroundOnly ||
        status == FriendsOnMapActivationStatus.activeWithBackground;

    _timer?.cancel();
    _timer = null;
    ref.onDispose(() => _timer?.cancel());

    if (!reporting) {
      return;
    }
    _timer = Timer.periodic(_kReportInterval, (_) => unawaited(_reportOnce()));
    // Report immediately on activation rather than waiting for the first
    // tick — otherwise a friend would see nothing for up to a full interval
    // after the user turns the feature on.
    unawaited(_reportOnce());
  }

  Future<void> _reportOnce() async {
    // R-16: reporting continues while paused — visibility is suppressed at
    // the read side (Part B), not by withholding collection here. This
    // method is therefore never gated on `friendsOnMapPausedProvider`.
    final position = ref.read(locationProvider);
    if (position == null) {
      return;
    }
    if (!ref.mounted) {
      return;
    }
    await ref.read(friendsOnMapPositionRepositoryProvider).reportPosition(position);
    if (!ref.mounted) {
      return;
    }
    logger.log('friends_on_map: reported position lat=${position.latitude} lon=${position.longitude}');
  }
}
