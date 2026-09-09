/// Server-side counterpart of the persistent invite link (conceptually
/// `GET /v1/me/invite-link` / `POST /v1/me/invite-link:reset`). Mocked for
/// this iteration — see `features/friends_on_map/AGENTS.md`.
abstract class InviteLinkRepository {
  Future<String> getInviteLink();

  Future<String> resetInviteLink();
}
