import 'package:dio/dio.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_api_exception.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_json.dart';
import 'package:mapness/features/friends_on_map/data/friends_repository.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';

/// Real backend implementation — `GET /v1/friends`, `DELETE /v1/friends/{id}`
/// (see `~/Downloads/friends-on-map/GO_BACKEND_SPEC.md`).
class RemoteFriendsRepository implements FriendsRepository {
  RemoteFriendsRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Friend>> getFriends() async {
    final response = await _dio.get<List<dynamic>>('/v1/friends');
    return (response.data ?? []).map((e) => friendFromJson(e as Map<String, dynamic>)).toList();
  }

  /// No-op against the real backend: accepting a friend request already
  /// establishes mutual visibility server-side (`handleAcceptRequest`) —
  /// there is no client-initiated "add to my list" call, unlike the mock
  /// this replaces (see `FriendsRepository.addFriend`'s doc comment). Kept
  /// so `FriendRequestsController.accept` doesn't need a repository-specific
  /// branch.
  @override
  Future<void> addFriend(Friend friend) async {}

  @override
  Future<void> removeFriend(String id) async {
    try {
      await _dio.delete<void>('/v1/friends/$id');
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }
}
