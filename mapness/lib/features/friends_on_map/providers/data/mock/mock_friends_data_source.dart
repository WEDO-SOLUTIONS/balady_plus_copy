import 'dart:async';
import 'dart:math';

import 'package:mapness/features/friends_on_map/model/friend_location.dart';
import 'package:mapness/features/friends_on_map/model/friend_location_event.dart';
import 'package:mapness/features/friends_on_map/providers/data/friends_data_source.dart';

/// Base coordinate friend seed points are offset from — matches the default
/// camera target used elsewhere (Kingdom Tower, Riyadh), see
/// `shared/providers/map/dgis_controller.dart`.
const double _baseLatitude = 24.712301;
const double _baseLongitude = 46.674175;

/// Rough km-per-degree at this latitude — precise enough for a mock scatter
/// radius, not for real distance math.
const double _kmPerDegree = 111.0;
const double _scatterRadiusKm = 10;

/// Bounds/defaults for the debug-panel sliders — see
/// `friends_debug_settings_provider.dart` and `friends_debug_panel.dart`.
const int kFriendsMockMinPoints = 5;
const int kFriendsMockMaxPoints = 200;
const int kFriendsMockDefaultPoints = 100;

const int kFriendsMockMinIntervalSeconds = 1;
const int kFriendsMockMaxIntervalSeconds = 10;
const int kFriendsMockDefaultIntervalSeconds = 3;

/// Fake friends "streaming" their location. [getFriendLocations] returns the
/// current snapshot once; [watchFriendLocationUpdates] then emits one
/// upsert/removal event per tick to simulate live movement (and the
/// occasional friend going offline), until a real backend replaces this.
///
/// The stream only ticks while it has a listener, so polling stops the
/// moment nothing is watching it (e.g. the friends layer is hidden).
///
/// [pointsCount] and [tickInterval] are driven live by the debug panel:
/// `friendsDataSourceProvider` watches the debug settings and recreates this
/// instance whenever either slider changes.
class MockFriendsDataSource extends FriendsDataSource {
  MockFriendsDataSource({int pointsCount = kFriendsMockDefaultPoints, this.tickInterval = _defaultTickInterval})
    : _friends = _seedFriends(pointsCount);

  static const _defaultTickInterval = Duration(seconds: kFriendsMockDefaultIntervalSeconds);

  final Duration tickInterval;
  final _random = Random();
  final List<FriendLocation> _friends;

  static List<FriendLocation> _seedFriends(int count) {
    final random = Random();
    return List.generate(count, (i) {
      final angle = random.nextDouble() * 2 * pi;
      final radius = random.nextDouble() * (_scatterRadiusKm / _kmPerDegree); // scatter within ~10km of base
      return FriendLocation(
        userId: 'friend-${i + 1}',
        latitude: _baseLatitude + radius * cos(angle),
        longitude: _baseLongitude + radius * sin(angle),
        lastUpdated: DateTime.now(),
        batteryLevel: 10 + random.nextInt(91),
      );
    });
  }

  StreamController<FriendLocationEvent>? _controller;
  Timer? _timer;

  @override
  Future<List<FriendLocation>> getFriendLocations() async => List.unmodifiable(_friends);

  @override
  Stream<FriendLocationEvent> watchFriendLocationUpdates() {
    _controller ??= StreamController<FriendLocationEvent>.broadcast(onListen: _startTicking, onCancel: _stopTicking);
    return _controller!.stream;
  }

  void _startTicking() {
    _timer ??= Timer.periodic(tickInterval, (_) => _tick());
  }

  void _stopTicking() {
    if (_controller?.hasListener ?? false) {
      return;
    }
    _timer?.cancel();
    _timer = null;
  }

  void _tick() {
    if (_friends.isEmpty) {
      return;
    }
    final index = _random.nextInt(_friends.length);
    final friend = _friends[index];

    // Occasionally simulate a friend stopping location sharing.
    const removalChance = 0.1;
    if (_friends.length > 1 && _random.nextDouble() < removalChance) {
      _friends.removeAt(index);
      _controller?.add(FriendLocationEvent.removed(friend.userId));
      return;
    }

    final moved = friend.copyWith(
      latitude: friend.latitude + (_random.nextDouble() - 0.5) * 0.001,
      longitude: friend.longitude + (_random.nextDouble() - 0.5) * 0.001,
      lastUpdated: DateTime.now(),
      batteryLevel: friend.batteryLevel <= 1 ? 100 : friend.batteryLevel - 1,
    );
    _friends[index] = moved;
    _controller?.add(FriendLocationEvent.updated(moved));
  }
}
