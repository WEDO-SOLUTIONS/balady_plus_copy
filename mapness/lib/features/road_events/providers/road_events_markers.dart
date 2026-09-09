import 'package:dgis_map/library.dart' hide RoadEventType;
import 'package:flutter/widgets.dart';
import 'package:mapness/features/map_tap_handler/map_tap_handler_provider.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/features/road_events/domain/road_event.dart';
import 'package:mapness/features/road_events/helpers/road_event_type_label.dart';
import 'package:mapness/features/road_events/providers/road_event_marker_bitmap.dart';
import 'package:mapness/features/road_events/providers/road_events_repository.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'road_events_markers.g.dart';

final roadEventsMarkersSettings = MapObjectManagerSettings.roadEvents();

Future<Marker> roadEventMarker(
  RoadEvent event,
  void Function() onTap, {
  required RoadEventMarkerBitmap bitmap,
  required double devicePixelRatio,
}) async => Marker(
  id: event.id,
  options: MarkerOptionsMessage(
    position: GeoPointWithElevationMessage(
      latitude: event.location.latitude,
      longitude: event.location.longitude,
      elevation: 1,
    ),
    icon: await _iconFor(event.type, bitmap, devicePixelRatio),
  ),
  onTap: onTap,
);

Future<MarkerIconMessage> _iconFor(RoadEventType type, RoadEventMarkerBitmap bitmap, double devicePixelRatio) async =>
    switch (type.icon()) {
      ToastIconAsset(:final asset) => asset.markerIcon(),
      ToastIconData() => PngBytesMarkerIcon(
        pngData: await bitmap.render(type: type, devicePixelRatio: devicePixelRatio),
        width: RoadEventMarkerBitmap.size,
      ),
    };

@Riverpod(keepAlive: true)
class RoadEventsMarkers extends _$RoadEventsMarkers {
  @override
  Future<void> build() async {
    final settings = roadEventsMarkersSettings;
    final mapObjectManager = ref.watch(
      mapObjectManagerProvider(named: settings.name, layerId: settings.layerId).notifier,
    );
    final eventsAsync = ref.watch(roadEventsRepositoryProvider);
    final events = eventsAsync.value;
    if (events == null) {
      return;
    }

    final roadEvents = ref.read(roadEventsProvider.notifier);
    final bitmap = ref.watch(roadEventMarkerBitmapProvider);
    final devicePixelRatio = WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    final markers = await Future.wait(
      events.map(
        (event) => roadEventMarker(
          event,
          () => roadEvents.handleTap(event),
          bitmap: bitmap,
          devicePixelRatio: devicePixelRatio,
        ),
      ),
    );

    await mapObjectManager.removeAllMarkers();
    await mapObjectManager.addMarkers(markers);
  }
}
