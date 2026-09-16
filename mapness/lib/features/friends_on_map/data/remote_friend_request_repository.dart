import 'package:dio/dio.dart';
import 'package:mapness/features/friends_on_map/data/friend_request_repository.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_api_exception.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_json.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/models/friend_request.dart';
import 'package:mapness/features/friends_on_map/models/invite_resolution.dart';

/// Real backend implementation (see
/// `~/Downloads/friends-on-map/GO_BACKEND_SPEC.md`): `POST
/// /v1/invites/{token}/resolve`, `GET /v1/friend-requests/incoming|outgoing`,
/// `POST /v1/friend-requests/{id}/accept|decline|cancel`.
class RemoteFriendRequestRepository implements FriendRequestRepository {
  RemoteFriendRequestRepository(this._dio);

  final Dio _dio;

  /// [ownToken] is unused here — the real server derives "is this my own
  /// link" from the authenticated caller's own stored invite token
  /// (`handleResolveInvite`), unlike the mock this replaces which had no
  /// caller identity to check against. Kept in the signature only because
  /// `FriendRequestRepository` is shared with the mock implementation.
  /// S-10: this endpoint is also where 3 of the 5 Appendix B limit codes
  /// surface (`pendingRequestLimitReached`, `requestCreationLimitReached`,
  /// `inviteResolutionRateLimited`) — see
  /// `data/friends_on_map_api_exception.dart` for the wire contract.
  @override
  Future<InviteResolution> resolveInvite({required String token, required String ownToken}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/v1/invites/$token/resolve');
      final result = response.data!['result'] as String;
      return InviteResolution.values.firstWhere((r) => r.name == result);
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<List<FriendRequest>> getIncomingRequests() => _getRequests('/v1/friend-requests/incoming');

  @override
  Future<List<FriendRequest>> getOutgoingRequests() => _getRequests('/v1/friend-requests/outgoing');

  Future<List<FriendRequest>> _getRequests(String path) async {
    final response = await _dio.get<List<dynamic>>(path);
    return (response.data ?? []).map((e) => friendRequestFromJson(e as Map<String, dynamic>)).toList();
  }

  /// S-10: also where `friendLimitReached` (Appendix B's 200-friend cap)
  /// surfaces — see `data/friends_on_map_api_exception.dart`.
  @override
  Future<Friend> acceptRequest(String id) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/v1/friend-requests/$id/accept');
      return friendFromJson(response.data!);
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  /// Tolerates a 404: `FriendRequestsController.blockIncoming` calls
  /// `blockUser` first (see `providers/friend_requests.dart` for why), and
  /// the server's own block handler already deletes the pending request
  /// between the two accounts as part of blocking — so by the time this
  /// call runs against the real backend, the request row is legitimately
  /// already gone. Treated as an idempotent success, not an error.
  @override
  Future<void> declineRequest(String id) async {
    try {
      await _dio.post<void>('/v1/friend-requests/$id/decline');
    } on DioException catch (e) {
      if (e.response?.statusCode != 404) {
        throw mapFriendsOnMapError(e);
      }
    }
  }

  @override
  Future<void> cancelRequest(String id) async {
    try {
      await _dio.post<void>('/v1/friend-requests/$id/cancel');
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }
}
