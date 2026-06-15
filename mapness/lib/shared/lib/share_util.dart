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
  static Future<String> getSharePOILink({
    required BuildContext context,
    String? objectId,
    Coordinates? markerCoords,
  }) async {
    try {
      final container = ProviderScope.containerOf(context, listen: false);
      return await container
          .read(shortLinkRepositoryProvider)
          .createLink(
            ShortLinkRequest(
              poiId: objectId,
              lat: markerCoords?.latitude,
              lon: markerCoords?.longitude,
            ),
          );
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

  static Future<void> sharePOI({
    required BuildContext context,
    String? objectId,
    Coordinates? markerCoords,
  }) async {
    final shareUrl = await getSharePOILink(
      context: context,
      objectId: objectId,
      markerCoords: markerCoords,
    );

    if (objectId == parkingObjectId.toString()) {
      return safeShareText('${context.l10n.leftMyCarHere} $shareUrl', context: context);
    }
    await safeShareText(shareUrl, context: context);
  }
}
