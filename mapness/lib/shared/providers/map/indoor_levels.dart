import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'indoor_levels.g.dart';

class LevelsState {
  final List<IndoorLevel> levels;
  final int active;

  LevelsState(this.levels, this.active);

  LevelsState copyWith({
    List<IndoorLevel>? levels,
    int? active,
  }) => LevelsState(
    levels ?? this.levels,
    active ?? this.active,
  );
}

/// Provider of indoor levels information. If [objectId] is passed, provider will handle [IndoorLevelsEvent] with this [objectId] only
@riverpod
class IndoorLevels extends _$IndoorLevels {
  StreamSubscription? _levelsSubscription;
  StreamSubscription? _indexSubscription;
  StreamSubscription? _hideLevelsSubscription;
  StreamSubscription? _cameraSubscription;

  @override
  LevelsState? build({int? objectId}) {
    final dgisController = ref.watch(dgisControllerProvider);

    _cancelSubscriptions();
    _subscribeToStreams(dgisController);

    final lastIndoorLevelNames = dgisController.value?.lastIndoorLevelNames;
    final lastIndoorActiveLevel = dgisController.value?.lastIndoorActiveLevel;

    state =
        lastIndoorLevelNames != null &&
            lastIndoorActiveLevel != null &&
            (objectId == null || lastIndoorLevelNames.objectId == objectId)
        ? LevelsState(
            lastIndoorLevelNames.levelNames,
            lastIndoorActiveLevel.index,
          )
        : null;

    ref.onDispose(() {
      _cancelSubscriptions();
    });

    return state;
  }

  Future<void> selectLevel(IndoorLevel level) async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    await dgisController.selectIndoorLevel(level);
  }

  void _indexListener(IndoorActiveLevelEvent event) {
    state = state?.copyWith(active: event.index) ?? LevelsState([], event.index);
  }

  Future<void> _levelsListener(AsyncValue<DgisMapController> dgisController, IndoorLevelsEvent levelEvent) async {
    if (objectId == null || objectId == levelEvent.objectId) {
      _cameraSubscription?.cancel();
      final object = await dgisController.value?.searchByObjectId(
        DgisObjectIdMessage(objectId: levelEvent.objectId, entranceId: 0),
      );
      final GeoPointWithElevationMessage objectCenter = object!.markerPosition!;
      final visibleArea = await dgisController.value?.getVisibleArea();
      final coords = (visibleArea?.contours.firstOrNull as List<Object?>?)?.cast<GeoPointMessage>() ?? [];

      _checkLevelIsVisible(coords, objectCenter, levelEvent);

      _cameraSubscription = dgisController.value?.visibleRectEvents.listen(
        (visibleRectEvent) {
          final visibleRectCoords = [
            GeoPointMessage(
              latitude: visibleRectEvent.visibleRect.northEastLat,
              longitude: visibleRectEvent.visibleRect.northEastLon,
            ),
            GeoPointMessage(
              latitude: visibleRectEvent.visibleRect.southWestLat,
              longitude: visibleRectEvent.visibleRect.southWestLon,
            ),
          ];
          _checkLevelIsVisible(visibleRectCoords, objectCenter, levelEvent);
        },
      );
    }
  }

  void _checkLevelIsVisible(
    List<GeoPointMessage> coords,
    GeoPointWithElevationMessage objectCenter,
    IndoorLevelsEvent event,
  ) {
    final lats = coords.map((e) => e.latitude);
    final lons = coords.map((e) => e.longitude);
    final minLat = lats.min;
    final maxLat = lats.max;
    final minLon = lons.min;
    final maxLon = lons.max;
    final isCenterOfObjectVisibleOnMap =
        objectCenter.latitude > minLat &&
        objectCenter.latitude < maxLat &&
        objectCenter.longitude > minLon &&
        objectCenter.longitude < maxLon;
    if (objectId == null || objectId == event.objectId) {
      if (isCenterOfObjectVisibleOnMap) {
        state = state?.copyWith(levels: event.levelNames) ?? LevelsState(event.levelNames, 0);
      } else {
        state = null;
      }
    }
  }

  void _subscribeToStreams(AsyncValue<DgisMapController> dgisController) {
    _levelsSubscription = dgisController.value?.indoorLevelNames.listen(
      (event) => _levelsListener(dgisController, event),
    );
    _indexSubscription = dgisController.value?.indoorActiveIndex.listen(_indexListener);
    _hideLevelsSubscription = dgisController.value?.hideIndoorLevels.listen((_) {
      state = null;
      _cameraSubscription?.cancel();
    });
  }

  void _cancelSubscriptions() {
    _levelsSubscription?.cancel();
    _levelsSubscription = null;
    _indexSubscription?.cancel();
    _indexSubscription = null;
    _hideLevelsSubscription?.cancel();
    _hideLevelsSubscription = null;
    _cameraSubscription?.cancel();
  }
}
