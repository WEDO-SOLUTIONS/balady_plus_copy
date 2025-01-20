import 'package:mapness/entities/metro/metro_line_model.dart';
import 'package:mapness/features/metro/metro_layer_visible_provider.dart';
import 'package:mapness/features/metro/metro_line_json_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'metro_layer_repository.g.dart';

@riverpod
class MetroLayerRepository extends _$MetroLayerRepository {
  @override
  Future<List<MetroLineModel>> build() {
    final metroLayerJsonDatasource = MetroLineJsonDatasource();

    return metroLayerJsonDatasource.getMetroLineInfo();
  }

  void showMetro() {
    ref.read(metroLayerVisibleProvider.notifier).showMetro();
  }

  void hideMetro() {
    ref.read(metroLayerVisibleProvider.notifier).hideMetro();
  }

  void toggleMetro() {
    final isMetroVisible = ref.read(metroLayerVisibleProvider);
    isMetroVisible ? hideMetro() : showMetro();
  }
}
