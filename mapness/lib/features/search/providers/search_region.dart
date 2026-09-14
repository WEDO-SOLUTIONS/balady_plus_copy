import 'package:dio/dio.dart';
import 'package:mapness/entities/search/models/search_region.dart';
import 'package:mapness/shared/lib/deeplink_functions.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:mapness/shared/providers/vendor_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_region.g.dart';

/// A singleton service class for region search operations.
class SearchRegionService {
  static SearchRegionService? _instance;
  static Dio? _dio;

  (double, double)? _lastLocation;
  SearchRegion? _lastResult;
  bool _isInitialized = false;
  String? _key;
  String? _regionSearchUrl;

  // Private constructor for Singleton
  SearchRegionService._();

  // Singleton instance getter
  // ignore: prefer_constructors_over_static_methods
  static SearchRegionService get instance {
    _instance ??= SearchRegionService._();
    return _instance!;
  }

  /// Initialize the service with Dio instance
  Future<void> initialize({required Dio dio, required String key, required String regionSearchUrl}) async {
    if (_isInitialized) {
      return;
    }

    _dio = dio;
    _key = key;
    _regionSearchUrl = regionSearchUrl;
    _isInitialized = true;
  }

  /// Gets the Dio instance for HTTP requests.
  Dio get dio {
    if (_dio == null) {
      throw StateError('SearchRegionService has not been initialized. Call initialize() first.');
    }
    return _dio!;
  }

  /// Searches for a region based on the provided coordinates.
  Future<SearchRegion?> getRegion({
    required double latitude,
    required double longitude,
  }) async {
    try {
      if (_regionSearchUrl == null) {
        throw Exception('Region search URL is not initialized');
      }

      if (_key == null) {
        throw Exception('Key is not initialized');
      }

      // Return cached result if coordinates haven't changed
      if (_lastLocation == (latitude, longitude) && _lastResult != null) {
        return _lastResult;
      }

      _lastLocation = (latitude, longitude);

      final response = await dio.get(
        _regionSearchUrl!,
        queryParameters: {
          BaldayDeeplink.qKey: '$longitude,$latitude',
          BaldayDeeplink.keyKey: _key,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final result = data['result'] as Map<String, dynamic>;
      final items = result['items'] as List<dynamic>;

      if (items.isEmpty) {
        throw Exception('No region found for coordinates: $latitude, $longitude');
      }

      // Return the first (most relevant) region
      final regionData = items.first as Map<String, dynamic>;
      // ignore: join_return_with_assignment
      _lastResult = SearchRegion.fromJson(regionData);
      return _lastResult;
    } catch (e) {
      rethrow;
    }
  }

  // Dispose method to clean up resources
  void dispose() {
    _dio?.close();
    _dio = null;
    _isInitialized = false;
    _instance = null;
  }

  // Check if service is initialized
  bool get isInitialized => _isInitialized;
}

/// Helper function to initialize SearchRegionService with Riverpod dependencies
@riverpod
Future<void> initializeSearchRegionService(Ref ref) async {
  final baseDio = ref.read(baseDioProvider);

  final vendorConfig = await ref.read(vendorConfigProvider.future);
  final catalogApi = vendorConfig[BaldayDeeplink.catalogKey];
  final key = vendorConfig[BaldayDeeplink.vendorConfigKey];

  final regionSearchUrl = BaldayDeeplink.searchBoundRegion(catalogApi);

  await SearchRegionService.instance.initialize(dio: baseDio, key: key, regionSearchUrl: regionSearchUrl);
}
