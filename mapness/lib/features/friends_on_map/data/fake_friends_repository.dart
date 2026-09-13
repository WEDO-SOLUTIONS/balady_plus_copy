import 'package:mapness/features/friends_on_map/data/friends_repository.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';

/// In-memory stand-in for the real friend list endpoint. Seeded with a
/// fixed sample so the list, search and empty-state UI are each
/// independently verifiable without a real backend — see
/// `features/friends_on_map/AGENTS.md` for the mocked-backend scope
/// decision this implements. The backing list is mutable so an accepted
/// friend request (R-22) can actually appear here.
///
/// `lastPositionAt` backs R-53's elapsed-time-on-the-card only — it's the
/// moment this repository (and so its seed data) was created, not a real
/// per-position-update server timestamp (see `models/friend.dart`).
///
/// Positions are small fixed offsets (~80-150m) from the same landmark
/// coordinate `shared/providers/map/dgis_controller.dart`'s `_kingdomTower`
/// constant uses for the map's own default camera position (24.712301,
/// 46.674175) — not a separately-sourced coordinate — so every seeded
/// friend renders as a visible marker (R-48) on-screen at the app's default
/// zoom (17) with no panning or extra setup.
class FakeFriendsRepository implements FriendsRepository {
  // `lastPositionAt` is set to the moment this repository instance is
  // created (app start), not const — see the class doc's R-53 note.
  final List<Friend> _friends = [
    Friend(
      id: '1',
      displayName: 'Sara Al-Otaibi',
      latitude: 24.7131,
      longitude: 46.6748,
      lastPositionAt: DateTime.now(),
    ),
    Friend(
      id: '2',
      displayName: 'Mohammed bin Khalid Al-Harbi',
      latitude: 24.7114,
      longitude: 46.6735,
      lastPositionAt: DateTime.now(),
    ),
    Friend(id: '3', displayName: 'Noura', latitude: 24.7127, longitude: 46.6733, lastPositionAt: DateTime.now()),
  ];

  @override
  Future<List<Friend>> getFriends() async => List.unmodifiable(_friends);

  @override
  Future<void> addFriend(Friend friend) async {
    _friends.add(friend);
  }

  @override
  Future<void> removeFriend(String id) async {
    _friends.removeWhere((f) => f.id == id);
  }
}
