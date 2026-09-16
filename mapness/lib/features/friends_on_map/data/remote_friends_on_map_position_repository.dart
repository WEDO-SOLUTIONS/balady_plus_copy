import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_position_repository.dart';

/// Real backend implementation — `POST /v1/positions/me` (see
/// `~/Downloads/friends-on-map/GO_BACKEND_SPEC.md`).
class RemoteFriendsOnMapPositionRepository implements FriendsOnMapPositionRepository {
  RemoteFriendsOnMapPositionRepository(this._dio);

  final Dio _dio;

  @override
  Future<void> reportPosition(Position position) async {
    await _dio.post<void>('/v1/positions/me', data: {'latitude': position.latitude, 'longitude': position.longitude});
  }
}
