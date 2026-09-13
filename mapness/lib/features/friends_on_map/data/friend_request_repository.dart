import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/models/friend_request.dart';
import 'package:mapness/features/friends_on_map/models/invite_resolution.dart';

/// Server-side counterpart of the friend-request graph (conceptually
/// `POST /v1/friend-requests`, `GET /v1/friend-requests`,
/// `POST /v1/friend-requests/{id}:accept` etc.). Mocked for this iteration
/// — see `features/friends_on_map/AGENTS.md`.
abstract class FriendRequestRepository {
  /// [ownToken] is the caller's own current invite token — a real backend
  /// would resolve "is this my own link" server-side from the authenticated
  /// caller's identity; the mocked implementation needs it passed in since
  /// there's no server to ask. See `FakeFriendRequestRepository`.
  Future<InviteResolution> resolveInvite({required String token, required String ownToken});

  /// R-36: requests addressed to the current user.
  Future<List<FriendRequest>> getIncomingRequests();

  /// R-37: requests the current user has sent, still pending.
  Future<List<FriendRequest>> getOutgoingRequests();

  /// R-22/R-38: accepting establishes mutual visibility — returns the new
  /// [Friend] so the caller can add it to the friend list.
  Future<Friend> acceptRequest(String id);

  /// R-38: declining is silent — no notification, no friend created.
  Future<void> declineRequest(String id);

  /// R-37: withdraws a request this user sent.
  Future<void> cancelRequest(String id);
}
