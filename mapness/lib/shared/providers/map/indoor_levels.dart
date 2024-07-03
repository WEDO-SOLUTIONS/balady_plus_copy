import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'indoor_levels.g.dart';

class LevelsState {

  LevelsState(this.levels, this.active);
  final List<IndoorLevel> levels;
  final int active;

  LevelsState copyWith({
    List<IndoorLevel>? levels,
    int? active,
  }) => LevelsState(
        levels ?? this.levels,
        active ?? this.active,
      );
}

@riverpod
class IndoorLevels extends _$IndoorLevels {
  StreamSubscription? _levelsSubscription;
  StreamSubscription? _indexSubscription;

  @override
  LevelsState? build() {
    final dgisController = ref.watch(dgisControllerProvider);

    _subscribeToStreams(dgisController);

    ref.onDispose(() {
      _cancelSubscriptions();
      dgisController.value?.disposeIndoorEventHandler;
    });

    return null;
  }

  Future<void> selectLevel(IndoorLevel level) async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    await dgisController.selectIndoorLevel(level);
  }

  void _indexListener(IndoorActiveLevelEvent event) {
    state = state?.copyWith(active: event.index) ?? LevelsState([], event.index);
  }

  void _levelsListener(IndoorLevelsEvent event) {
    if (event.levelNames.isEmpty) {
      state = null;
    } else {
      state = state?.copyWith(levels: event.levelNames) ??
          LevelsState(event.levelNames, 0);
    }
  }

  Future<void> _subscribeToStreams(AsyncValue<DgisMapController> dgisController) async {
    _levelsSubscription = dgisController.value?.indoorLevelNames.listen(_levelsListener);
    _indexSubscription = dgisController.value?.indoorActiveIndex.listen(_indexListener);
  }

  void _cancelSubscriptions() {
    _levelsSubscription?.cancel();
    _indexSubscription?.cancel();
  }
}