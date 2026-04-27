import 'package:balady_plus/app/core/utils/utils_exports.dart' as balady_utils;
import 'package:dgis_map/library.dart';
import 'package:flutter/services.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/landing/map_controls.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/lib/deeplink_functions.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'poi_card_actions_provider.g.dart';

@Riverpod(keepAlive: true)
class PoiCardActions extends _$PoiCardActions {
  @override
  void build() {}

  void onError() => Future(() => ref.read(mapControlsProvider.notifier).update(MapControlsStateIdle()));

  Future<void> onEntranceTap(DirectoryObjectMessage? objectMessage) async {
    final controller = await ref.read(dgisControllerProvider.future);
    if (objectMessage != null) {
      final list = objectMessage.entrances.map((e) => e.id).nonNulls.toList();
      await controller.setHighlighted(list);
    }
  }

  Future<void> share({required int? objectId, LatLng? markerCoords}) {
    if (objectId == null) {
      onError();
      return Future.value();
    }
    final baseUri = BaldayDeeplink.basePoiUri;
    final query = <String, String>{};

    query[BaldayDeeplink.dgisObjectIdKey] = objectId.toString();

    if (markerCoords != null) {
      query[BaldayDeeplink.latitudeKey] = markerCoords.latitude.toString();
      query[BaldayDeeplink.longitudeKey] = markerCoords.longitude.toString();
    }

    final context = rootNavigatorKey.currentContext;
    if (context == null) {
      return Future.value();
    }
    final shareUrl = BaldayDeeplink.urlWithQuery(baseUri, query);
    if (objectId == parkingObjectId) {
      return balady_utils.safeShareText('${context.l10n.leftMyCarHere} $shareUrl', context: context);
    }
    return balady_utils.safeShareText(shareUrl, context: context);
  }

  String _myLocationDeeplink(LatLng location) => BaldayDeeplink.urlWithQuery(BaldayDeeplink.basePoiUri, {
    BaldayDeeplink.latitudeKey: location.latitude.toString(),
    BaldayDeeplink.longitudeKey: location.longitude.toString(),
    BaldayDeeplink.typeKey: BaldayDeeplink.typeValueMyLocation,
  });

  void shareMyLocation(LatLng? location) {
    if (location != null) {
      final context = rootNavigatorKey.currentContext;
      if (context == null) {
        return;
      }
      balady_utils.safeShareText(_myLocationDeeplink(location), context: context);
    } else {
      onError();
    }
  }

  Future<void> copyToClipboard(LatLng? location) async {
    if (location != null) {
      await Clipboard.setData(ClipboardData(text: _myLocationDeeplink(location)));
    }
  }

  Future<void> sendEmail(String value) async {
    await launchUrl(Uri(scheme: 'mailto', path: value, queryParameters: {'subject': ''}));
  }

  Future<void> launch(String value) async {
    final url = Uri.parse(value);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> callPhone(String value) async {
    await launchUrl(Uri(scheme: 'tel', path: value));
  }

  void resetMapControlsState() {
    ref.read(mapControlsProvider.notifier).update(MapControlsStateIdle());
  }

  Future<void> toggleEntrances(DirectoryObjectMessage data, VoidCallback callBack, LatLng? closestPoint) async {
    final entranceIds = data.entrances.map((e) => e.id).toList();
    if (entranceIds.isEmpty) {
      return;
    }

    final highlightController = ref.read(highlightProvider.notifier);
    final currentHighlights = ref.read(highlightProvider);

    final entranceKeys = entranceIds.map((id) => id.entranceId).toSet();
    final entrancesAreShown = currentHighlights.any(
      (h) => entranceKeys.contains(h.entranceId),
    );

    Metrics.logEventAdvanced(
      MetricsConstants.poiKeys.entrances,
      group: MetricsConstants.poiTag,
      action: MetricAction.tap.toString(),
      props: {'poi_id': data.id?.objectId, 'show_entrances': !entrancesAreShown},
    );

    if (entrancesAreShown) {
      for (final id in entranceIds) {
        await highlightController.removeHighlight(id);
      }
    } else {
      for (final id in entranceIds) {
        await highlightController.addHighlight(id);
      }
      await _animateToEntrance(
        data.entrances.map((e) => e.geometry?.entrancePoints ?? []).toList().expand((element) => element).toList(),
        closestPoint,
      );
    }

    callBack.call();
  }

  Future<void> _animateToEntrance(List<GeoPointMessage?> data, LatLng? closestPoint) async {
    if (data.isEmpty) {
      return;
    }

    // Remove all null values
    final points = data.where((element) => element != null);

    if (points.isEmpty) {
      return;
    }

    double minDistance = double.infinity;
    GeoPointMessage? minCoords;
    // Find the minimum distance to entrance
    for (final point in points) {
      final distance = CommonFunctions.distance(
        point!.latitude,
        point.longitude,
        closestPoint?.latitude ?? 0,
        closestPoint?.longitude ?? 0,
      );
      if (distance <= minDistance) {
        minDistance = distance;
        minCoords = point;
      }
    }

    if (minCoords == null) {
      return;
    }

    final cameraController = ref.read(cameraPositionProvider.notifier);
    final cameraPosition = ref.read(cameraPositionProvider);
    // Animate to the entrance
    await cameraController.animateTo(
      CameraPositionMessage(
        point: GeoPointMessage(latitude: minCoords.latitude, longitude: minCoords.longitude),
        zoom: 17.3,
        tilt: cameraPosition?.tilt ?? 0,
        bearing: cameraPosition?.tilt ?? 0,
      ),
    );
  }
}
