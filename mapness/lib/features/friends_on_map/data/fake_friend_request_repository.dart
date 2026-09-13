import 'package:mapness/features/friends_on_map/data/friend_request_repository.dart';
import 'package:mapness/features/friends_on_map/models/invite_resolution.dart';

/// In-memory stand-in for resolving an invite token into a pending friend
/// request. By the time this is called, the caller (`invite_resolution_flow.dart`)
/// has already confirmed the scanned/opened string is shaped like a Balady
/// invite link — this only decides self-request vs success.
///
/// R-35 (duplicate request / already friends) is deliberately not modeled:
/// there is no second real account in a single-device mock to be "already
/// friends" with, and every non-self token here belongs to nobody real —
/// faking that check would mean inventing state with nothing behind it. See
/// `features/friends_on_map/AGENTS.md`.
class FakeFriendRequestRepository implements FriendRequestRepository {
  final List<String> pendingRequestTokens = [];

  @override
  Future<InviteResolution> resolveInvite({required String token, required String ownToken}) async {
    if (token == ownToken) {
      return InviteResolution.selfRequest;
    }
    pendingRequestTokens.add(token);
    return InviteResolution.success;
  }
}
