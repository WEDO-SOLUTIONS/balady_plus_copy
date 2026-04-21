import 'package:mapness/entities/makkah_buses/model.dart';
import 'package:mapness/features/makkah_bus/visible_provider.dart';
import 'package:mapness/features/makkah_bus/datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repo.g.dart';

@riverpod
class MakkahBusLayerRepo extends _$MakkahBusLayerRepo {
  @override
  Future<List<MakkahBusModel>> build() => MakkahBusJsonDatasource().getInfo();

  void show() {
    ref.read(makkahBusLayerVisibleProvider.notifier).show();
  }

  void hide() {
    ref.read(makkahBusLayerVisibleProvider.notifier).hide();
  }

  void toggle() {
    final isVisible = ref.read(makkahBusLayerVisibleProvider);
    isVisible ? hide() : show();
  }
}
