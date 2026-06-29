import 'package:dgis_map/library.dart';
import 'package:flutter/services.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/landing/map_controls.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/entities/coordinates.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/lib/share_util.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/ui/toast/toast_overlay.dart';

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

  Future<void> share({required int? objectId, LatLng? markerCoords}) async {
    final context = rootNavigatorKey.currentContext;
    if (objectId == null || context == null) {
      onError();
      return;
    }

    final coordinates = markerCoords == null
        ? null
        : Coordinates(latitude: markerCoords.latitude, longitude: markerCoords.longitude);
    ShareUtil.sharePOI(context: context, objectId: objectId.toString(), markerCoords: coordinates);
  }

  void shareMyLocation(LatLng? location) {
    if (location != null) {
      final context = rootNavigatorKey.currentContext;
      if (context == null) {
        return;
      }
      ShareUtil.sharePOI(
        context: context,
        markerCoords: Coordinates(latitude: location.latitude, longitude: location.longitude),
      );
    } else {
      onError();
    }
  }

  Future<void> copyToClipboard(LatLng? location) async {
    if (location != null) {
      final context = rootNavigatorKey.currentContext;
      if (context == null) {
        return;
      }

      ToastOverlay.of(context).show(
        title: context.l10n.copyToastMsg,
        actions: [
          ToastAction(title: context.l10n.feedbackBreaksSheetClose),
        ],
      );

      final shareLink = await ShareUtil.getSharePOILink(
        context: context,
        markerCoords: Coordinates(latitude: location.latitude, longitude: location.longitude),
      );
      await Clipboard.setData(ClipboardData(text: shareLink));
    }
  }

  Future<void> sendEmail(String value) async {
    await launchUrl(Uri(scheme: 'mailto', path: value, queryParameters: {'subject': ''}));
  }

  Future<void> launch(String value) async {
    String urlString = value;
    if (value.contains('wa.me/') || value.contains('api.whatsapp.com/')) {
      urlString = urlString.replaceFirst(RegExp(r'[?&]text=[^&]*'), '');
    }
    final url = Uri.parse(urlString);
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
