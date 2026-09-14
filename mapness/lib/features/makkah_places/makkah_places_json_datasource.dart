import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/entities/makkah_places/makkah_place_model.dart';
import 'package:mapness/shared/config/environment_config.dart';
import 'package:mapness/shared/providers/makkah_config_staging.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class MakkahPlacesIconCache {
  MakkahPlacesIconCache._();

  static final MakkahPlacesIconCache instance = MakkahPlacesIconCache._();

  final Map<String, String> _iconPathsByPlaceId = {};
  final Set<String> _downloadingPlaceIds = {};
  String? _cacheDir;

  /// Returns local file path for the cached SVG icon.
  /// Returns empty string if download failed (prevents retries).
  /// Returns null if not cached yet.
  String? iconPathFor(String? placeId) {
    if (placeId == null || placeId.isEmpty) {
      return null;
    }
    return _iconPathsByPlaceId[placeId];
  }

  Future<void> preloadIcons(Dio dio, List<MakkahPlace> places) async {
    _cacheDir ??= (await getTemporaryDirectory()).path;

    final futures = <Future<void>>[];

    for (final place in places) {
      final placeId = place.placeId;
      final url = place.markerImageUrl;

      // Skip if placeId/url is invalid, already cached, or currently downloading
      if (placeId == null ||
          placeId.isEmpty ||
          url == null ||
          url.isEmpty ||
          _iconPathsByPlaceId.containsKey(placeId) ||
          _downloadingPlaceIds.contains(placeId)) {
        continue;
      }

      // Mark as downloading to prevent race condition
      _downloadingPlaceIds.add(placeId);
      futures.add(_downloadIcon(dio, placeId, url));
    }

    await Future.wait(futures);
  }

  Future<void> preloadPreviewImages(List<MakkahPlace> places) async {
    final futures = <Future<void>>[];

    for (final place in places) {
      final previewUrl = place.previewImageUrl;
      if (previewUrl == null || previewUrl.isEmpty) {
        continue;
      }

      futures.add(_preloadImage(previewUrl));

      for (final photoUrl in place.photoUrls ?? <String>[]) {
        if (photoUrl.trim().isNotEmpty) {
          futures.add(_preloadImage(photoUrl));
        }
      }
    }

    await Future.wait(futures);
  }

  Future<void> _preloadImage(String url) async {
    ImageStream? stream;
    ImageStreamListener? listener;

    try {
      final provider = CachedNetworkImageProvider(url);
      stream = provider.resolve(const ImageConfiguration());
      final completer = Completer<void>();

      listener = ImageStreamListener(
        (_, __) {
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
        onError: (e, _) {
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      );

      stream.addListener(listener);

      await completer.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      );
    } catch (e) {
      logger.log(
        'MakkahPlaces: Failed to preload image $url: $e',
        logLevel: MapnessLogLevel.warning,
      );
    } finally {
      // Always clean up listener to prevent memory leaks
      if (stream != null && listener != null) {
        stream.removeListener(listener);
      }
    }
  }

  Future<void> _downloadIcon(Dio dio, String placeId, String url) async {
    try {
      final response = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final ext = url.toLowerCase().endsWith('.svg') ? 'svg' : 'png';
        final filePath = '$_cacheDir/makkah_place_$placeId.$ext';
        final file = File(filePath);
        await file.writeAsBytes(response.data!);
        _iconPathsByPlaceId[placeId] = filePath;
      } else {
        // Mark as failed with empty string to prevent retries
        _iconPathsByPlaceId[placeId] = '';
        logger.log(
          'MakkahPlaces: Failed to download icon for $placeId: HTTP ${response.statusCode}',
          logLevel: MapnessLogLevel.warning,
        );
      }
    } catch (e) {
      logger.log(
        'MakkahPlaces: Failed to download icon for $placeId: $e',
        logLevel: MapnessLogLevel.warning,
      );
      // Mark as failed with empty string to prevent infinite retries
      _iconPathsByPlaceId[placeId] = '';
    } finally {
      // Always remove from downloading set
      _downloadingPlaceIds.remove(placeId);
    }
  }
}

List<MakkahPlace> parseMakkahPlacesJson(String jsonInput) {
  final json = jsonDecode(jsonInput) as List<dynamic>;
  return json.map((item) {
    final map = item as Map<String, dynamic>;
    final place = MakkahPlace.fromJson(map);

    // Expected: markerImageUrl = SVG (for map pin), previewImageUrl = PNG (for card)
    // If swapped, fix it
    final markerUrl = place.markerImageUrl ?? '';
    final previewUrl = place.previewImageUrl ?? '';

    final markerIsSvg = markerUrl.toLowerCase().endsWith('.svg');
    final previewIsPng = previewUrl.toLowerCase().endsWith('.png');

    // If marker is PNG and preview is SVG — they are swapped, fix it
    if (!markerIsSvg && !previewIsPng) {
      final markerIsPng = markerUrl.toLowerCase().endsWith('.png');
      final previewIsSvg = previewUrl.toLowerCase().endsWith('.svg');

      if (markerIsPng && previewIsSvg) {
        return place.copyWith(
          markerImageUrl: previewUrl,
          previewImageUrl: markerUrl,
        );
      }
    }

    return place;
  }).toList();
}

class MakkahPlacesJsonDatasource {
  MakkahPlacesJsonDatasource({
    required this.dio,
    required this.env,
  });

  final Dio dio;
  final DgisEnv env;

  static const _cacheFileName = 'makkah_places_cache.json';
  static const _cacheStagingFileName = 'makkah_places_cache_staging.json';

  String? _cacheFilePath;

  bool get _isStaging => MakkahConfigUrls.isStagingEnv(env);
  String get _remoteUrl => MakkahConfigUrls.getPlacesUrl(env);
  String get _cacheFile => _isStaging ? _cacheStagingFileName : _cacheFileName;

  Future<List<MakkahPlace>> getPlaces() async {
    List<MakkahPlace> places;

    try {
      final response = await dio.get<dynamic>(
        _remoteUrl,
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final jsonOutput = jsonEncode(response.data);
        places = parseMakkahPlacesJson(jsonOutput);
        await _saveToCache(jsonOutput);
      } else {
        places = await _loadFromCacheOrAssets();
      }
    } on DioException catch (e) {
      logger.log(
        'MakkahPlaces: Failed to fetch from remote, falling back to cache/assets. Error: $e',
        logLevel: MapnessLogLevel.warning,
      );
      places = await _loadFromCacheOrAssets();
    } catch (e) {
      logger.log(
        'MakkahPlaces: Unexpected error fetching remote data: $e',
        logLevel: MapnessLogLevel.warning,
      );
      places = await _loadFromCacheOrAssets();
    }

    // Preload marker icons and preview images before returning
    await Future.wait([
      MakkahPlacesIconCache.instance.preloadIcons(dio, places),
      MakkahPlacesIconCache.instance.preloadPreviewImages(places),
    ]);

    return places;
  }

  Future<String> _getCacheFilePath() async {
    if (_cacheFilePath != null) {
      return _cacheFilePath!;
    }
    final dir = await getApplicationDocumentsDirectory();
    _cacheFilePath = '${dir.path}/$_cacheFile';
    return _cacheFilePath!;
  }

  Future<void> _saveToCache(String jsonOutput) async {
    try {
      final path = await _getCacheFilePath();
      final file = File(path);
      await file.writeAsString(jsonOutput);
    } catch (e) {
      logger.log(
        'MakkahPlaces: Failed to save cache: $e',
        logLevel: MapnessLogLevel.warning,
      );
    }
  }

  Future<List<MakkahPlace>> _loadFromCacheOrAssets() async {
    try {
      final path = await _getCacheFilePath();
      final file = File(path);
      if (await file.exists()) {
        final jsonOutput = await file.readAsString();
        return parseMakkahPlacesJson(jsonOutput);
      }
    } catch (e) {
      logger.log(
        'MakkahPlaces: Failed to load from cache, falling back to assets: $e',
        logLevel: MapnessLogLevel.warning,
      );
    }
    return _loadFromAssets();
  }

  Future<List<MakkahPlace>> _loadFromAssets() async {
    final jsonOutput = await rootBundle.loadString('assets/places.json');
    return parseMakkahPlacesJson(jsonOutput);
  }
}
