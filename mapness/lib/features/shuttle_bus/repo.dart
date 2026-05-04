import 'package:mapness/entities/makkah_buses/model.dart';
import 'visible_provider.dart';
import 'datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repo.g.dart';

@riverpod
class ShuttleBusLayerRepo extends _$ShuttleBusLayerRepo {
  @override
  Future<List<MakkahBusModel>> build() => ShuttleBusJsonDatasource().getInfo();

  void show() => ref.read(shuttleBusLayerVisibleProvider.notifier).show();

  void hide() => ref.read(shuttleBusLayerVisibleProvider.notifier).hide();

  void toggle() => ref.read(shuttleBusLayerVisibleProvider) ? hide() : show();
}
