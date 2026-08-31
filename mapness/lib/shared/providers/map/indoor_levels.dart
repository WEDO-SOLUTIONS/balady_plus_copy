import 'dart:async';

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
  StreamSubscription? _hideIndoorLevelsSubscription;
  StreamSubscription? _indexSubscription;
  StreamSubscription? _hideLevelsSubscription;
  StreamSubscription<NavigationEvent>? _freeRoamSubscription;

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

  void _levelsListener(IndoorLevelsEvent event) {
    if (objectId == null || objectId == event.objectId) {
      state = state?.copyWith(levels: event.levelNames) ?? LevelsState(event.levelNames, 0);
    }
  }

  void _hideIndoorLevelsListener(HideIndoorLevelsEvent event) {
    state = LevelsState([], 0);
  }

  Future<void> _subscribeToStreams(AsyncValue<DgisMapController> dgisController) async {
    _levelsSubscription = dgisController.value?.indoorLevelNames.listen(_levelsListener);
    _hideIndoorLevelsSubscription = dgisController.value?.hideIndoorLevels.listen(_hideIndoorLevelsListener);
    _indexSubscription = dgisController.value?.indoorActiveIndex.listen(_indexListener);
    _hideLevelsSubscription = dgisController.value?.hideIndoorLevels.listen((_) => state = null);
    _freeRoamSubscription = dgisController.value?.freeRoamController.events.listen((freeRoamState) {
      // there's a bug that SDK won't emit level data event when moving camera on free roam start
      // so we turn it off manually
      if (freeRoamState == NavigationEvent.navigation || freeRoamState == NavigationEvent.routeSearch) {
        state = null;
      }
    });
  }

  void _cancelSubscriptions() {
    _levelsSubscription?.cancel();
    _levelsSubscription = null;
    _hideIndoorLevelsSubscription?.cancel();
    _hideIndoorLevelsSubscription = null;
    _indexSubscription?.cancel();
    _indexSubscription = null;
    _hideLevelsSubscription?.cancel();
    _hideLevelsSubscription = null;
    _freeRoamSubscription?.cancel();
    _freeRoamSubscription = null;
  }
}
