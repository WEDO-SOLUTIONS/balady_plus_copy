/// Server-side counterpart of the global visibility pause (conceptually
/// `PUT /v1/me/visibility`). Mocked for this iteration — see
/// `features/friends_on_map/AGENTS.md`.
abstract class FriendsOnMapVisibilityRepository {
  Future<void> setPaused({required bool paused});
}
