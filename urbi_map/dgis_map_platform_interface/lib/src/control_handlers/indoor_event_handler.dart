import 'dart:async';

import '../events/indoor_events.dart';
import '../pigeons/messages.g.dart';

class IndoorEventHandler {
  IndoorEventHandler(this._api);

  Stream<IndoorLevelsEvent> get indoorLevelNames =>
      _indoorLevelNamesController.stream;

  Stream<IndoorActiveLevelEvent> get indoorActiveLevel =>
      _indoorActiveLevelController.stream;

  final _indoorLevelNamesController = StreamController<IndoorLevelsEvent>();
  final _indoorActiveLevelController =
      StreamController<IndoorActiveLevelEvent>();

  final MapApi _api;

  void levelNamesEvent(Map<dynamic, dynamic> map) {
    final result = map['value'] as List<Object?>;
    final levelNames = result.whereType<String>();
    _indoorLevelNamesController.sink.add(
      IndoorLevelsEvent(
        levelNames
            .mapIndexed((index, level) => IndoorLevel(
                  level,
                  index,
                ))
            .toList(),
      ),
    );
  }

  void activeLevelEvent(Map<dynamic, dynamic> map) {
    _indoorActiveLevelController.sink.add(
      IndoorActiveLevelEvent(map['value']),
    );
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
