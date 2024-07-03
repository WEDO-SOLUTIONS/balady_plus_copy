import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/indoor_events.dart';
import 'package:dgis_map_platform_interface/src/pigeons/messages.g.dart';

class IndoorEventHandler {
  IndoorEventHandler(this._api);

  Stream<IndoorLevelsEvent> get indoorLevelNames => _indoorLevelNamesController.stream;
  Stream<IndoorActiveLevelEvent> get indoorActiveLevel => _indoorActiveLevelController.stream;

  final _indoorLevelNamesController = StreamController<IndoorLevelsEvent>.broadcast();
  final _indoorActiveLevelController = StreamController<IndoorActiveLevelEvent>.broadcast();

  final MapApi _api;

  IndoorLevelsEvent? get lastIndoorLevelNames => _lastIndoorLevelNames;
  IndoorActiveLevelEvent? get lastIndoorActiveLevel => _lastIndoorActiveLevel;

  IndoorLevelsEvent? _lastIndoorLevelNames;
  IndoorActiveLevelEvent? _lastIndoorActiveLevel;

  void levelNamesEvent(Map<dynamic, dynamic> map) {
    final result = map['value'] as List<Object?>;
    final levelNames = result.whereType<String>();
    final event = IndoorLevelsEvent(
      levelNames
          .mapIndexed((index, level) => IndoorLevel(
                level,
                index,
              ))
          .toList(),
    );
    _lastIndoorLevelNames = event;
    _indoorLevelNamesController.add(event);
  }

  void activeLevelEvent(Map<dynamic, dynamic> map) {
    final event = IndoorActiveLevelEvent(map['value']);
    _lastIndoorActiveLevel = event;
    _indoorActiveLevelController.add(event);
  }

  Future<void> selectIndoorLevel(int index) => _api.selectIndoorLevel(index);

  Future<void> dispose() async {
    await _indoorLevelNamesController.close();
    await _indoorActiveLevelController.close();
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
