import 'package:mapness/features/friends_on_map/models/active_share.dart';
import 'package:mapness/features/friends_on_map/models/share_mode.dart';
import 'package:mapness/features/friends_on_map/providers/active_shares_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_shares_controller.g.dart';

/// R-83: this account's own active shares, refetched from the server as the
/// sole source of truth — no local persistence at all (a deliberate choice,
/// closing the gap `share_eta`'s own engine has: its `EtaStreamStorage` is a
/// non-persisted in-memory singleton, lost on app kill).
///
/// keepAlive: same reasoning as `friends_repository.dart` — must survive
/// whichever sheet reads it being unmounted/remounted, and answer "how many
/// active shares" app-wide (e.g. for the status-view row's count), not only
/// while one sheet is open.
@Riverpod(keepAlive: true)
class ActiveSharesController extends _$ActiveSharesController {
  @override
  Future<List<ActiveShare>> build() => ref.read(activeSharesRepositoryProvider).listShares();

  /// R-78/R-79/R-80: starts a new live-location share. A
  /// `FriendsOnMapApiException` with `limitCode == shareLimitReached`
  /// (AC-10) propagates to the caller to be caught by
  /// `runFriendsOnMapAction`/`showFriendsOnMapLimitDialog` — not swallowed
  /// here.
  Future<({String id, String token})> startLiveShare(Duration duration) async {
    final result = await ref.read(activeSharesRepositoryProvider).createShare(mode: ShareMode.live, duration: duration);
    if (ref.mounted) {
      ref.invalidateSelf();
    }
    return (id: result.id, token: result.token);
  }

  /// R-85: starts a new eta-mode share toward [destLat]/[destLon] — only
  /// reachable while turn-by-turn navigation is active (see
  /// `ui/widgets/friends_on_map_eta_share_btn.dart`).
  Future<({String id, String token})> startEtaShare(
    Duration duration, {
    required double destLat,
    required double destLon,
  }) async {
    final result = await ref
        .read(activeSharesRepositoryProvider)
        .createShare(mode: ShareMode.eta, duration: duration, destLat: destLat, destLon: destLon);
    if (ref.mounted) {
      ref.invalidateSelf();
    }
    return (id: result.id, token: result.token);
  }

  /// R-83's stop action.
  Future<void> stop(String id) async {
    await ref.read(activeSharesRepositoryProvider).stopShare(id);
    if (!ref.mounted) {
      return;
    }
    ref.invalidateSelf();
  }
}
