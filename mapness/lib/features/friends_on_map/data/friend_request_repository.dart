import 'package:mapness/features/friends_on_map/models/invite_resolution.dart';

/// Server-side counterpart of resolving a scanned or opened invite token
/// (conceptually `POST /v1/friend-requests` addressed to the token's
/// owner). Mocked for this iteration — see
/// `features/friends_on_map/AGENTS.md`.
abstract class FriendRequestRepository {
  /// [ownToken] is the caller's own current invite token — a real backend
  /// would resolve "is this my own link" server-side from the authenticated
  /// caller's identity; the mocked implementation needs it passed in since
  /// there's no server to ask. See `FakeFriendRequestRepository`.
  Future<InviteResolution> resolveInvite({required String token, required String ownToken});
}
