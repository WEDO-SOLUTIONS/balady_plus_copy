import 'package:mapness/entities/makkah_places/makkah_place_model.dart';
import 'package:mapness/features/makkah_places/makkah_places_json_datasource.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'makkah_places_repository.g.dart';

@riverpod
class MakkahPlacesRepository extends _$MakkahPlacesRepository {
  @override
  Future<List<MakkahPlace>> build() async {
    final dio = ref.watch(baseDioProvider);
    final env = await ref.watch(dgisEnvTypeProvider.future);
    final datasource = MakkahPlacesJsonDatasource(dio: dio, env: env);

    try {
      final places = await datasource.getPlaces();

      // Track successful load
      Metrics.logEventAdvanced(
        MetricsConstants.makkahPlacesKeys.placesLoaded,
        group: MetricsConstants.makkahPlacesTag,
        props: {'count': places.length},
      );

      return places;
    } catch (e) {
      // Track load failure
      Metrics.logEventAdvanced(
        MetricsConstants.makkahPlacesKeys.placesLoadFailed,
        group: MetricsConstants.makkahPlacesTag,
        props: {'error': e.toString()},
      );
      rethrow;
    }
  }
}
