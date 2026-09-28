import 'package:dio/dio.dart';
import 'package:mapness/features/friends_on_map/data/active_shares_repository.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_api_exception.dart';
import 'package:mapness/features/friends_on_map/models/active_share.dart';
import 'package:mapness/features/friends_on_map/models/share_mode.dart';

/// Real backend implementation — `POST /v1/shares`, `GET /v1/shares`,
/// `POST /v1/shares/{id}/stop`, `POST /v1/shares/{id}/position` (see
/// `~/Downloads/friends-on-map/GO_BACKEND_SPEC.md`'s S-19 addendum).
class RemoteActiveSharesRepository implements ActiveSharesRepository {
  RemoteActiveSharesRepository(this._dio);

  final Dio _dio;

  @override
  Future<({String id, String token, ActiveShare share})> createShare({
    required ShareMode mode,
    required Duration duration,
    double? destLat,
    double? destLon,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/shares',
        data: {
          'mode': mode.wireValue,
          'durationMinutes': duration.inMinutes,
          if (destLat != null && destLon != null) 'destination': {'lat': destLat, 'lon': destLon},
        },
      );
      final data = response.data!;
      final id = data['id'] as String;
      final token = data['token'] as String;
      return (
        id: id,
        token: token,
        share: ActiveShare(
          id: id,
          mode: mode,
          createdAt: DateTime.parse(data['createdAt'] as String),
          expiresAt: DateTime.parse(data['expiresAt'] as String),
        ),
      );
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<List<ActiveShare>> listShares() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/v1/shares');
      final shares = (response.data?['shares'] as List<dynamic>?) ?? [];
      return shares.map((e) => ActiveShare.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<void> stopShare(String id) async {
    try {
      await _dio.post<void>('/v1/shares/$id/stop');
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<void> reportPosition(
    String id, {
    required double lat,
    required double lon,
    DateTime? etaArrivalAt,
    double? etaDistanceMeters,
  }) async {
    try {
      await _dio.post<void>(
        '/v1/shares/$id/position',
        data: {
          'lat': lat,
          'lon': lon,
          if (etaArrivalAt != null && etaDistanceMeters != null)
            'eta': {'arrivalAt': etaArrivalAt.toUtc().toIso8601String(), 'distanceMeters': etaDistanceMeters},
        },
      );
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }
}
