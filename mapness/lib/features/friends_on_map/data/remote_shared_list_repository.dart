import 'package:dio/dio.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_api_exception.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_json.dart';
import 'package:mapness/features/friends_on_map/data/shared_list_repository.dart';
import 'package:mapness/features/friends_on_map/models/shared_list.dart';
import 'package:mapness/features/friends_on_map/models/shared_list_detail.dart';
import 'package:mapness/features/friends_on_map/models/shared_list_item.dart';

/// Real backend implementation — see
/// `~/dev/code/wedo/go/balady-friends-service`'s `internal/api/handlers_lists.go`.
class RemoteSharedListRepository implements SharedListRepository {
  RemoteSharedListRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<SharedList>> getLists() async {
    try {
      final response = await _dio.get<List<dynamic>>('/v1/lists');
      return (response.data ?? []).map((e) => sharedListFromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<SharedListDetail> getList(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/v1/lists/$id');
      return sharedListDetailFromJson(response.data!);
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<SharedList> create(String name) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/v1/lists', data: {'name': name});
      return sharedListFromJson(response.data!);
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _dio.delete<void>('/v1/lists/$id');
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<void> addMembers(String listId, List<String> accountIds) async {
    try {
      await _dio.post<void>('/v1/lists/$listId/members', data: {'accountIds': accountIds});
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<void> removeMember(String listId, String accountId) async {
    try {
      await _dio.delete<void>('/v1/lists/$listId/members/$accountId');
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<void> leave(String listId) async {
    try {
      await _dio.post<void>('/v1/lists/$listId/leave');
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<SharedListItem> addItem(
    String listId, {
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/lists/$listId/places',
        data: {'latitude': latitude, 'longitude': longitude, 'label': label},
      );
      return sharedListItemFromJson(response.data!);
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }

  @override
  Future<void> removeItem(String listId, String itemId) async {
    try {
      await _dio.delete<void>('/v1/lists/$listId/places/$itemId');
    } on DioException catch (e) {
      throw mapFriendsOnMapError(e);
    }
  }
}
