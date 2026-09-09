import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:mapness/features/friends_on_map/models/friends_on_map_activation_status.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_activated.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_activation_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_on_map_activation.g.dart';

// keepAlive: watched from the map screen's resume hook (R-07) as well as the
// Friends on Map page itself — an auto-dispose provider would drop that
// state the moment the page closes and the map's revoked-toast listener
// would rebuild it into a fresh, wrong "notActivated" read.
@Riverpod(keepAlive: true)
class FriendsOnMapActivation extends _$FriendsOnMapActivation {
  @override
  FutureOr<FriendsOnMapActivationStatus> build() async {
    final activated = ref.watch(friendsOnMapActivatedProvider);
    if (!activated) {
      return FriendsOnMapActivationStatus.notActivated;
    }
    return _statusFromLivePermission();
  }

  Future<FriendsOnMapActivationStatus> _statusFromLivePermission() async {
    // Foreground vs background is only distinguishable through Geolocator's
    // `LocationPermission` — permission_handler's `Permission.location`
    // collapses whileInUse/always into one granted status. Same reasoning as
    // `shared/providers/location.dart`'s `_startInsiderGeofenceIfNeeded` and
    // `entry_point.dart`'s `enableInsiderGeofenceAfterConsent`.
    final permission = await Geolocator.checkPermission();
    return switch (permission) {
      LocationPermission.always => FriendsOnMapActivationStatus.activeWithBackground,
      LocationPermission.whileInUse => FriendsOnMapActivationStatus.activeForegroundOnly,
      _ => FriendsOnMapActivationStatus.revoked,
    };
  }

  /// R-03/R-05: requests the OS foreground permission. Returns whether it's
  /// granted; on denial, sets [FriendsOnMapActivationStatus.foregroundDenied]
  /// directly rather than persisting it — recoverable purely by re-checking
  /// live permission on resume (see [refreshPermissionStatus]).
  Future<bool> requestForegroundPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state = const AsyncData(FriendsOnMapActivationStatus.foregroundDenied);
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final granted = permission == LocationPermission.whileInUse || permission == LocationPermission.always;
    if (!granted) {
      state = const AsyncData(FriendsOnMapActivationStatus.foregroundDenied);
    }
    return granted;
  }

  /// R-04: optional upgrade to background ("always") permission. Only
  /// meaningful once foreground is already granted — calling
  /// `Geolocator.requestPermission()` again is what surfaces the OS
  /// "upgrade to Always" prompt on a permission that's already whileInUse.
  Future<bool> requestBackgroundPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always;
  }

  /// Completes activation: calls the (mocked) backend, persists the
  /// activated flag, and re-derives status from the live permission.
  Future<void> completeActivation({required bool backgroundGranted}) async {
    await ref.read(friendsOnMapActivationRepositoryProvider).activate(backgroundLocationGranted: backgroundGranted);
    ref.read(friendsOnMapActivatedProvider.notifier).setActivated(activated: true);
    state = AsyncData(await _statusFromLivePermission());
  }

  /// S-06/R-08: deactivates the feature. Flipping the persisted flag is the
  /// single source of truth `FriendsOnMapPositionReporter` watches, so
  /// reporting stops as a direct consequence of that provider's `build()`
  /// re-running — no separate "stop reporting" call is needed here. Per BR-03
  /// of S-06, the pause flag is untouched: it has no expiry and isn't tied
  /// to the activation lifecycle.
  Future<void> deactivate() async {
    ref.read(friendsOnMapActivatedProvider.notifier).setActivated(activated: false);
    state = const AsyncData(FriendsOnMapActivationStatus.notActivated);
  }

  /// R-07 (post-activation) / denied-view recovery (pre-activation):
  /// re-checks the live OS permission and updates [state] accordingly. Safe
  /// to call whenever the app resumes, activated or not.
  Future<void> refreshPermissionStatus() async {
    if (!ref.read(friendsOnMapActivatedProvider)) {
      final permission = await Geolocator.checkPermission();
      final granted = permission == LocationPermission.whileInUse || permission == LocationPermission.always;
      state = AsyncData(
        granted ? FriendsOnMapActivationStatus.notActivated : FriendsOnMapActivationStatus.foregroundDenied,
      );
      return;
    }
    state = AsyncData(await _statusFromLivePermission());
  }
}
