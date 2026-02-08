import 'package:mapness/entities/makkah_places/makkah_place_model.dart';
import 'package:mapness/features/makkah_places/makkah_places_json_datasource.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'makkah_places_repository.g.dart';

@riverpod
class MakkahPlacesRepository extends _$MakkahPlacesRepository {
  @override
  Future<List<MakkahPlace>> build() {
    final dio = ref.watch(baseDioProvider);
    final datasource = MakkahPlacesJsonDatasource(dio: dio);

    return datasource.getPlaces();
  }
}
