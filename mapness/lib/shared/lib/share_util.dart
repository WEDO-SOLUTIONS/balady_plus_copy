import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/entities/coordinates.dart';
import 'package:mapness/shared/lib/deeplink_functions.dart';
import 'package:mapness/shared/providers/short_link_repository.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

class ShareUtil {
  static Future<void> sharePOI({
    required BuildContext context,
    String? objectId,
    Coordinates? markerCoords,
  }) async {
    final shareUrl = await getSharePOILink(context: context, objectId: objectId, markerCoords: markerCoords);
    await safeShareText(shareUrl, context: context);
  }

  static Future<String> getSharePOILink({
    required BuildContext context,
    String? objectId,
    Coordinates? markerCoords,
  }) async {
    try {
      // TODO(darth-mobile): make 2 separate functions to share required POI or share required coords. Now I can skip all params and break the function
      if (objectId == null) {
        if (markerCoords == null) {
          throw ArgumentError('objectId and markerCoords are null');
        }
        return await _getShortLink(
          context,
          ShortLinkRequest.point(
            payload: ShortLinkPayloadPoint(lat: markerCoords.latitude, lon: markerCoords.longitude),
          ),
        );
      }
      final container = ProviderScope.containerOf(context, listen: false);
      final response = await container
          .read(shortLinkRepositoryProvider)
          .createLink(
            ShortLinkRequest.poi(
              payload: ShortLinkPayloadPoi(
                poiId: objectId,
                lat: markerCoords?.latitude,
                lon: markerCoords?.longitude,
              ),
              visibility: ShortLinkVisibility.public,
            ),
          );
      return response.shortUrl;
    } catch (e) {
      logger.log(
        'Failed to create short link: $e',
        logLevel: MapnessLogLevel.error,
      );

      final baseUri = BaldayDeeplink.basePoiUri;
      final query = <String, String>{};

      query[BaldayDeeplink.dgisObjectIdKey] = objectId.toString();

      if (markerCoords != null) {
        query[BaldayDeeplink.latitudeKey] = markerCoords.latitude.toString();
        query[BaldayDeeplink.longitudeKey] = markerCoords.longitude.toString();
      }

      return BaldayDeeplink.urlWithQuery(baseUri, query);
    }
  }

  static Future<void> sharePoint({
    required BuildContext context,
    required ShortLinkPayloadPoint data,
  }) => _shareShortLink(context, ShortLinkRequest.point(payload: data));

  static Future<void> shareTrip({
    required BuildContext context,
    required ShortLinkPayloadTrip data,
  }) => _shareShortLink(
    context,
    ShortLinkRequest.trip(payload: data, visibility: ShortLinkVisibility.public),
  );

  static Future<void> _shareShortLink(
    BuildContext context,
    ShortLinkRequest request,
  ) async {
    try {
      final shareUrl = await _getShortLink(context, request);
      await safeShareText(shareUrl, context: context);
    } catch (e) {
      logger.log(
        'Failed to create short link: $e',
        logLevel: MapnessLogLevel.error,
      );
    }
  }

  static Future<String> _getShortLink(
    BuildContext context,
    ShortLinkRequest request,
  ) async {
    try {
      final container = ProviderScope.containerOf(context, listen: false);
      final response = await container.read(shortLinkRepositoryProvider).createLink(request);
      return response.shortUrl;
    } catch (e) {
      logger.log(
        'Failed to create short link: $e',
        logLevel: MapnessLogLevel.error,
      );
      rethrow;
    }
  }
}
