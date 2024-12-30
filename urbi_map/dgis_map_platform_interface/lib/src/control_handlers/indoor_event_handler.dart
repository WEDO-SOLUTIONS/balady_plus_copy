import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/indoor_events.dart';
import 'package:dgis_map_platform_interface/src/pigeons/messages.g.dart';

/// Handler of indoor levels events
class IndoorEventHandler {
  /// Handler of indoor levels events
  IndoorEventHandler(this._api);

  /// Indoor levels events stream
  Stream<IndoorLevelsEvent> get indoorLevelNames => _indoorLevelNamesController.stream;

  /// Indoor levels hiding events stream
  Stream<HideIndoorLevelsEvent> get hideIndoorLevels => _hideLevelsController.stream;

  /// Indoor active level selection events stream
  Stream<IndoorActiveLevelEvent> get indoorActiveLevel => _indoorActiveLevelController.stream;

  final _indoorLevelNamesController = StreamController<IndoorLevelsEvent>.broadcast();
  final _hideLevelsController = StreamController<HideIndoorLevelsEvent>.broadcast();
  final _indoorActiveLevelController = StreamController<IndoorActiveLevelEvent>.broadcast();

  final MapApi _api;

  /// Getting latest [IndoorLevelsEvent]
  IndoorLevelsEvent? get lastIndoorLevelNames => _lastIndoorLevelNames;

  /// Getting latest [IndoorActiveLevelEvent]
  IndoorActiveLevelEvent? get lastIndoorActiveLevel => _lastIndoorActiveLevel;

  IndoorLevelsEvent? _lastIndoorLevelNames;
  IndoorActiveLevelEvent? _lastIndoorActiveLevel;

  /// Handles [IndoorLevelsEvent]
  void levelNamesEvent(Map<dynamic, dynamic> map) {
    final result = map['value'] as List<Object?>;
    final levelNames = result.whereType<String>();
    final objectId = map['objectId'];
    if (objectId == null || levelNames.isEmpty) {
      return;
    }

    final event = IndoorLevelsEvent(
      levelNames.mapIndexed((index, level) => IndoorLevel(level, index)).toList(),
      objectId,
    );
    _lastIndoorLevelNames = event;
    _indoorLevelNamesController.add(event);
  }

  /// Handles [HideIndoorLevelsEvent]
  void hideLevelsEvent() {
    _lastIndoorLevelNames = null;
    _hideLevelsController.add(HideIndoorLevelsEvent());
  }

  /// Handles [IndoorActiveLevelEvent]
  void activeLevelEvent(Map<dynamic, dynamic> map) {
    final event = IndoorActiveLevelEvent(map['value']);
    _lastIndoorActiveLevel = event;
    _indoorActiveLevelController.add(event);
  }

  /// Select indoor level
  Future<void> selectIndoorLevel(int index) => _api.selectIndoorLevel(index);

  /// Dispose
  Future<void> dispose() async {
    await _indoorLevelNamesController.close();
    await _indoorActiveLevelController.close();
    await _hideLevelsController.close();
  }
}

extension _MapIndexed<T> on Iterable<T> {
  Iterable<R> mapIndexed<R>(R Function(int index, T element) mapper) sync* {
    var index = 0;
    for (final element in this) {
      yield mapper(index++, element);
    }
  }
}
