import 'package:mapness/features/friends_on_map/data/friends_on_map_visibility_repository.dart';

/// In-memory stand-in for the real visibility endpoint. No network call is
/// made — see `features/friends_on_map/AGENTS.md` for the mocked-backend
/// scope decision this implements.
class FakeFriendsOnMapVisibilityRepository implements FriendsOnMapVisibilityRepository {
  bool lastPaused = false;

  @override
  Future<void> setPaused({required bool paused}) async {
    lastPaused = paused;
  }
}
