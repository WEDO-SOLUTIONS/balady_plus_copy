import 'package:mapness/entities/makkah_buses/model.dart';
import 'package:mapness/features/jeddah_bus/visible_provider.dart';
import 'package:mapness/features/jeddah_bus/datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repo.g.dart';

@riverpod
class JeddahBusLayerRepo extends _$JeddahBusLayerRepo {
  @override
  Future<JeddahBusData> build() => JeddahBusJsonDatasourceGist().getInfo();

  void show() {
    ref.read(jeddahBusLayerVisibleProvider.notifier).show();
  }

  void hide() {
    ref.read(jeddahBusLayerVisibleProvider.notifier).hide();
  }

  void toggle() {
    final isVisible = ref.read(jeddahBusLayerVisibleProvider);
    isVisible ? hide() : show();
  }
}
