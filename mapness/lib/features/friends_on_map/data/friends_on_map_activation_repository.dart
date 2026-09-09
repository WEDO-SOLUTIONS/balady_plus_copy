/// Server-side counterpart of activation (conceptually `POST
/// /v1/me/activation`). The real backend for Friends on Map is mocked for
/// this iteration — see `features/friends_on_map/AGENTS.md` — so this
/// interface exists purely as the seam a Dio-backed implementation replaces
/// later, without the provider/UI layer above it changing.
abstract class FriendsOnMapActivationRepository {
  Future<void> activate({required bool backgroundLocationGranted});
}
