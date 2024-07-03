import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../events/indoor_events.dart';
import '../pigeons/messages.g.dart';

class IndoorEventHandler {
  IndoorEventHandler(this._api);

  ValueStream<IndoorLevelsEvent> get indoorLevelNames => _indoorLevelNamesSubject.stream;

  ValueStream<IndoorActiveLevelEvent> get indoorActiveLevel => _indoorActiveLevelSubject.stream;

  final _indoorLevelNamesSubject = BehaviorSubject<IndoorLevelsEvent>();
  final _indoorActiveLevelSubject = BehaviorSubject<IndoorActiveLevelEvent>();

  final MapApi _api;

  void levelNamesEvent(Map<dynamic, dynamic> map) {
    final result = map['value'] as List<Object?>;
    final levelNames = result.whereType<String>();
    _indoorLevelNamesSubject.add(
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
    _indoorActiveLevelSubject.add(IndoorActiveLevelEvent(map['value']));
  }

  Future<void> selectIndoorLevel(int index) => _api.selectIndoorLevel(index);

  Future<void> dispose() async {
    await _indoorLevelNamesSubject.close();
    await _indoorActiveLevelSubject.close();
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
