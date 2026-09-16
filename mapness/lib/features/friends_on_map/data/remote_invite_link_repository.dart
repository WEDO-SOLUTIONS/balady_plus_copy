import 'package:dio/dio.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_api_exception.dart';
import 'package:mapness/features/friends_on_map/data/invite_link_repository.dart';
import 'package:mapness/shared/lib/deeplink_functions.dart';

/// Real backend implementation — `GET /v1/me/invite-link`, `POST
/// /v1/me/invite-link/reset` (see
/// `~/Downloads/friends-on-map/GO_BACKEND_SPEC.md`). The server returns a
/// bare token, not a URL; wrapped here into the same
/// `https://plus.balady.gov.sa/invite/<token>` shape the client's QR/scan
/// flow (`providers/invite_resolution_flow.dart`) already expects from the
/// mock this replaces, so nothing downstream needs to change.
class RemoteInviteLinkRepository implements InviteLinkRepository {
  RemoteInviteLinkRepository(this._dio);

  final Dio _dio;

  @override
  Future<String> getInviteLink() async {
    final response = await _dio.get<Map<String, dynamic>>('/v1/me/invite-link');
    return _toLink(response.data!);
  }

  /// S-10: also where `inviteResetLimitReached` (Appendix B's 10-resets-per-
  /// 24h cap) surfaces — see `data/friends_on_map_api_exception.dart`.
  @override
  Future<String> resetInviteLink() async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/v1/me/invite-link/reset');
      return _toLink(response.data!);
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  String _toLink(Map<String, dynamic> json) =>
      '${BaldayDeeplink.baseAuthorityWithScheme}/invite/${json['token'] as String}';
}
