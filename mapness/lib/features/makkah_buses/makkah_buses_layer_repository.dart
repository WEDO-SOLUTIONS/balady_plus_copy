import 'package:mapness/entities/makkah_buses/makkah_buses_model.dart';
import 'package:mapness/features/makkah_buses/makkah_buses_layer_visible_provider.dart';
import 'package:mapness/features/makkah_buses/makkah_buses_json_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'makkah_buses_layer_repository.g.dart';

@riverpod
class MakkahBusesLayerRepository extends _$MakkahBusesLayerRepository {
  @override
  Future<List<MakkahBusesModel>> build() {
    final makkahBusesJsonDatasource = MakkahBusesJsonDatasource();

    return makkahBusesJsonDatasource.getMakkahBusesInfo();
  }

  void showMakkahBuses() {
    ref.read(makkahBusesLayerVisibleProvider.notifier).showMakkahBuses();
  }

  void hideMakkahBuses() {
    ref.read(makkahBusesLayerVisibleProvider.notifier).hideMakkahBuses();
  }

  void toggleMakkahBuses() {
    final isMakkahBusesVisible = ref.read(makkahBusesLayerVisibleProvider);
    isMakkahBusesVisible ? hideMakkahBuses() : showMakkahBuses();
  }
}
