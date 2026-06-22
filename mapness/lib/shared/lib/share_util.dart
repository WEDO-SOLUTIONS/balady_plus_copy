import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/shared/entities/coordinates.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/deeplink_functions.dart';
import 'package:mapness/shared/providers/short_link_repository.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

class ShareUtil {
  static Future<void> sharePOI(
    String? objectId, {
    required BuildContext context,
    Coordinates? markerCoords,
  }) async {
    String shareUrl;
    try {
      if (objectId == null) {
        throw ArgumentError('Object id is null');
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
            ),
          );
      shareUrl = response.shortUrl;
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

      shareUrl = BaldayDeeplink.urlWithQuery(baseUri, query);
    }

    if (objectId == parkingObjectId.toString()) {
      return safeShareText('${context.l10n.leftMyCarHere} $shareUrl', context: context);
    }
    await safeShareText(shareUrl, context: context);
  }

  static Future<void> sharePoint({
    required BuildContext context,
    required ShortLinkPayloadPoint data,
  }) => _shareShortLink(context, ShortLinkRequest.point(payload: data));

  static Future<void> shareTrip({
    required BuildContext context,
    required ShortLinkPayloadTrip data,
  }) => _shareShortLink(context, ShortLinkRequest.trip(payload: data));

  static Future<void> _shareShortLink(
    BuildContext context,
    ShortLinkRequest request,
  ) async {
    try {
      final container = ProviderScope.containerOf(context, listen: false);
      final response = await container.read(shortLinkRepositoryProvider).createLink(request);
      final shareUrl = response.shortUrl;
      await safeShareText(shareUrl, context: context);
    } catch (e) {
      logger.log(
        'Failed to create short link: $e',
        logLevel: MapnessLogLevel.error,
      );
    }
  }
}
