import 'package:dio/dio.dart';
import 'package:mapness/features/friends_on_map/data/blocked_users_repository.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_json.dart';
import 'package:mapness/features/friends_on_map/models/blocked_user.dart';

/// Real backend implementation — `GET/POST /v1/blocks`, `DELETE
/// /v1/blocks/{id}` (see `~/Downloads/friends-on-map/GO_BACKEND_SPEC.md`).
class RemoteBlockedUsersRepository implements BlockedUsersRepository {
  RemoteBlockedUsersRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<BlockedUser>> getBlockedUsers() async {
    final response = await _dio.get<List<dynamic>>('/v1/blocks');
    return (response.data ?? []).map((e) => blockedUserFromJson(e as Map<String, dynamic>)).toList();
  }

  /// [user.id] is either an invite-request token (blocking an incoming
  /// request) or a friend's account id (blocking an existing friend) — the
  /// server resolves either shape server-side (`handleBlockUser`) and
  /// removes any existing friendship/pending requests as part of blocking.
  @override
  Future<void> blockUser(BlockedUser user) async {
    await _dio.post<void>('/v1/blocks', data: {'id': user.id});
  }

  @override
  Future<void> unblockUser(String id) async {
    await _dio.delete<void>('/v1/blocks/$id');
  }
}
