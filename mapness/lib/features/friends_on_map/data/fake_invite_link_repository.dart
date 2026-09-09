import 'package:mapness/features/friends_on_map/data/invite_link_repository.dart';
import 'package:mapness/shared/lib/deeplink_functions.dart';
import 'package:uuid/uuid.dart';

/// In-memory stand-in for the real invite-link endpoint. Persistence of
/// "the current link" across app restarts is the caller's job (see
/// `providers/friends_on_map_invite_link.dart`) — this fake is stateless and
/// simply mints a new token-based URL on every call, matching how the real
/// server would generate one. No network call is made — see
/// `features/friends_on_map/AGENTS.md` for the mocked-backend scope
/// decision this implements.
class FakeInviteLinkRepository implements InviteLinkRepository {
  static const _uuid = Uuid();

  @override
  Future<String> getInviteLink() async => _mintLink();

  @override
  Future<String> resetInviteLink() async => _mintLink();

  String _mintLink() => '${BaldayDeeplink.baseAuthorityWithScheme}/invite/${_uuid.v4()}';
}
