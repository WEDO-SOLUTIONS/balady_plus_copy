import 'package:dio/dio.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_api_exception.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_json.dart';
import 'package:mapness/features/friends_on_map/data/meetup_repository.dart';
import 'package:mapness/features/friends_on_map/models/meetup.dart';

/// Real backend implementation — `POST/GET /v1/meetups`, `DELETE
/// /v1/meetups/{id}` (see `~/dev/code/wedo/go/balady-friends-service`'s
/// `internal/api/handlers_meetups.go`).
class RemoteMeetupRepository implements MeetupRepository {
  RemoteMeetupRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Meetup>> create({
    required List<String> recipientIds,
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    try {
      final response = await _dio.post<List<dynamic>>(
        '/v1/meetups',
        data: {'recipientIds': recipientIds, 'latitude': latitude, 'longitude': longitude, 'label': label},
      );
      return (response.data ?? []).map((e) => meetupFromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<List<Meetup>> getReceivedMeetups() async {
    try {
      final response = await _dio.get<List<dynamic>>('/v1/meetups');
      return (response.data ?? []).map((e) => meetupFromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<void> dismiss(String id) async {
    try {
      await _dio.delete<void>('/v1/meetups/$id');
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }
}
