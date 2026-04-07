import 'package:mapness/entities/makkah_buses/makkah_buses_model.dart';
import 'package:mapness/features/haram_shuttle/haram_shuttle_layer_visible_provider.dart';
import 'package:mapness/features/haram_shuttle/haram_shuttle_json_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'haram_shuttle_layer_repository.g.dart';

@riverpod
class HaramShuttleLayerRepository extends _$HaramShuttleLayerRepository {
  @override
  Future<List<MakkahBusesModel>> build() => HaramShuttleJsonDatasource().getHaramShuttleInfo();

  void showHaramShuttle() {
    ref.read(haramShuttleLayerVisibleProvider.notifier).showHaramShuttle();
  }

  void hideHaramShuttle() {
    ref.read(haramShuttleLayerVisibleProvider.notifier).hideHaramShuttle();
  }

  void toggleHaramShuttle() {
    final isHaramShuttleVisible = ref.read(haramShuttleLayerVisibleProvider);
    isHaramShuttleVisible ? hideHaramShuttle() : showHaramShuttle();
  }
}
