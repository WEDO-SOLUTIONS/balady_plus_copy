import 'package:dio/dio.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_api_exception.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_dio.dart';
import 'package:mapness/features/favorite_lists/data/models/custom_name_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_place_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/health_check_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/map_marker_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/migrate_legacy_favorites_result_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/place_type.dart';
import 'package:mapness/features/favorite_lists/data/models/share_link_dto.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_lists_remote_datasource.g.dart';

abstract class FavoriteListsRemoteDataSource {
  factory FavoriteListsRemoteDataSource({required final Dio dio}) => _FavoriteListsRemoteDataSource(dio: dio);

  Future<HealthCheckDto> getHealth();

  Future<FavoriteListsResponseDto> getFavoriteLists();

  Future<FavoriteListResponseDto> createFavoriteList(FavoriteListRequestDto request);

  Future<FavoriteListDetailResponseDto> getFavoriteListById(String listId);

  Future<FavoriteListResponseDto> updateFavoriteList(String listId, FavoriteListRequestDto request);

  Future<DeleteFavoriteListResultDto> deleteFavoriteList(String listId);

  Future<FavoriteListPlacesResponseDto> getPlacesInList(String listId);

  Future<AddPlaceResultDto> addPlaceToList(String listId, String placeId);

  Future<RemovePlaceResultDto> removePlaceFromList(String listId, String placeId);

  Future<BulkAssignResultDto> bulkAssignPlaceToLists(
    String placeId, {
    required final List<String> addToListIds,
    required final List<String> removeFromListIds,
  });

  Future<MapMarkersResponseDto> getAggregatedMapMarkers();

  Future<CustomNameResponseDto> setCustomPlaceNickname(
    String placeId,
    String customName, {
    final PlaceType placeType = PlaceType.poi,
  });

  Future<CustomNameResponseDto> getCustomPlaceNickname(
    String placeId, {
    final PlaceType placeType = PlaceType.poi,
  });

  Future<DeleteCustomNameResultDto> deleteCustomPlaceNickname(
    String placeId, {
    final PlaceType placeType = PlaceType.poi,
  });

  Future<ShareLinkDto> generateShareLink(String listId);

  Future<SharedListPreviewDto> previewShareLink(String shareToken);

  Future<AcceptShareLinkResultDto> acceptShareLink(String shareToken);

  Future<MigrateLegacyFavoritesResultDto> migrateLegacyFavorites(List<String> legacyPlaceIds);
}

class _FavoriteListsRemoteDataSource implements FavoriteListsRemoteDataSource {
  _FavoriteListsRemoteDataSource({required this.dio});

  final Dio dio;

  Map<String, dynamic> _unwrap(Response<dynamic> response) =>
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;

  Future<T> _request<T>(
    String label,
    Future<Response<dynamic>> Function() call,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await call();
      return fromJson(_unwrap(response));
    } on DioException catch (e) {
      logger.log('FAVORITE LISTS API [$label] DioException $e', logLevel: MapnessLogLevel.error);
      throw FavoriteListsApiException.fromDioException(e);
    }
  }

  @override
  Future<HealthCheckDto> getHealth() => _request('getHealth', () => dio.get('/health'), HealthCheckDto.fromJson);

  @override
  Future<FavoriteListsResponseDto> getFavoriteLists() =>
      _request('getFavoriteLists', () => dio.get('/favorite-lists'), FavoriteListsResponseDto.fromJson);

  @override
  Future<FavoriteListResponseDto> createFavoriteList(FavoriteListRequestDto request) => _request(
    'createFavoriteList',
    () => dio.post('/favorite-lists', data: request.toJson()),
    FavoriteListResponseDto.fromJson,
  );

  @override
  Future<FavoriteListDetailResponseDto> getFavoriteListById(String listId) => _request(
    'getFavoriteListById',
    () => dio.get('/favorite-lists/$listId'),
    FavoriteListDetailResponseDto.fromJson,
  );

  @override
  Future<FavoriteListResponseDto> updateFavoriteList(String listId, FavoriteListRequestDto request) => _request(
    'updateFavoriteList',
    () => dio.put('/favorite-lists/$listId', data: request.toJson()),
    FavoriteListResponseDto.fromJson,
  );

  @override
  Future<DeleteFavoriteListResultDto> deleteFavoriteList(String listId) => _request(
    'deleteFavoriteList',
    () => dio.delete('/favorite-lists/$listId'),
    DeleteFavoriteListResultDto.fromJson,
  );

  @override
  Future<FavoriteListPlacesResponseDto> getPlacesInList(String listId) => _request(
    'getPlacesInList',
    () => dio.get('/favorite-lists/$listId/places'),
    FavoriteListPlacesResponseDto.fromJson,
  );

  @override
  Future<AddPlaceResultDto> addPlaceToList(String listId, String placeId) => _request(
    'addPlaceToList',
    () => dio.post('/favorite-lists/$listId/places', data: AddPlaceRequestDto(placeId: placeId).toJson()),
    AddPlaceResultDto.fromJson,
  );

  @override
  Future<RemovePlaceResultDto> removePlaceFromList(String listId, String placeId) => _request(
    'removePlaceFromList',
    () => dio.delete('/favorite-lists/$listId/places/$placeId'),
    RemovePlaceResultDto.fromJson,
  );

  @override
  Future<BulkAssignResultDto> bulkAssignPlaceToLists(
    String placeId, {
    required final List<String> addToListIds,
    required final List<String> removeFromListIds,
  }) => _request(
    'bulkAssignPlaceToLists',
    () => dio.post(
      '/places/$placeId/favorite-lists',
      data: BulkAssignPlaceRequestDto(
        addToListIds: addToListIds,
        removeFromListIds: removeFromListIds,
      ).toJson(),
    ),
    BulkAssignResultDto.fromJson,
  );

  @override
  Future<MapMarkersResponseDto> getAggregatedMapMarkers() =>
      _request('getAggregatedMapMarkers', () => dio.get('/favorites/map'), MapMarkersResponseDto.fromJson);

  @override
  Future<CustomNameResponseDto> setCustomPlaceNickname(
    String placeId,
    String customName, {
    final PlaceType placeType = PlaceType.poi,
  }) => _request(
    'setCustomPlaceNickname',
    () => dio.put(
      '/places/$placeId/custom-name',
      data: CustomNameRequestDto(customName: customName).toJson(),
      queryParameters: {'placeType': placeType.apiValue},
    ),
    CustomNameResponseDto.fromJson,
  );

  @override
  Future<CustomNameResponseDto> getCustomPlaceNickname(
    String placeId, {
    final PlaceType placeType = PlaceType.poi,
  }) => _request(
    'getCustomPlaceNickname',
    () => dio.get(
      '/places/$placeId/custom-name',
      queryParameters: {'placeType': placeType.apiValue},
    ),
    CustomNameResponseDto.fromJson,
  );

  @override
  Future<DeleteCustomNameResultDto> deleteCustomPlaceNickname(
    String placeId, {
    final PlaceType placeType = PlaceType.poi,
  }) => _request(
    'deleteCustomPlaceNickname',
    () => dio.delete(
      '/places/$placeId/custom-name',
      queryParameters: {'placeType': placeType.apiValue},
    ),
    DeleteCustomNameResultDto.fromJson,
  );

  @override
  Future<ShareLinkDto> generateShareLink(String listId) => _request(
    'generateShareLink',
    () => dio.post('/favorite-lists/$listId/share'),
    ShareLinkDto.fromJson,
  );

  @override
  Future<SharedListPreviewDto> previewShareLink(String shareToken) => _request(
    'previewShareLink',
    () => dio.get('/shared/$shareToken'),
    SharedListPreviewDto.fromJson,
  );

  @override
  Future<AcceptShareLinkResultDto> acceptShareLink(String shareToken) => _request(
    'acceptShareLink',
    () => dio.post('/shared/$shareToken/accept'),
    AcceptShareLinkResultDto.fromJson,
  );

  @override
  Future<MigrateLegacyFavoritesResultDto> migrateLegacyFavorites(List<String> legacyPlaceIds) => _request(
    'migrateLegacyFavorites',
    () => dio.post('/favorites/migrate', data: {'legacyPlaceIds': legacyPlaceIds}),
    MigrateLegacyFavoritesResultDto.fromJson,
  );
}

@Riverpod(keepAlive: true)
Future<FavoriteListsRemoteDataSource> favoriteListsRemoteDataSource(Ref ref) async {
  final dio = await ref.watch(favoriteListsDioProvider.future);
  return FavoriteListsRemoteDataSource(dio: dio);
}
