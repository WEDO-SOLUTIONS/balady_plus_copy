import 'package:dio/dio.dart';
import 'package:mapness/entities/bus_departures/model.dart';
import 'package:mapness/features/bus_departures/providers/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/providers/app_language.dart' show appLanguageProvider, LanguageData;

part 'repo.g.dart';

@riverpod
class BusDeparturesRepo extends _$BusDeparturesRepo {
  @override
  void build() {}

  Future<BusDeparturesResponse?> getDepartures(String poiId) async {
    try {
      final dio = await ref.read(busDeparturesDioProvider.future);
      final appLanguage = ref.read(appLanguageProvider);
      final response = await dio.get(
        '$poiId/feed',
        options: Options(responseType: ResponseType.json),
        queryParameters: {'locale': appLanguage.languageCode},
      );
      final data = response.data;
      if (data == null) {
        return null;
      }
      return BusDeparturesResponse.fromJson(data);
    } catch (e) {
      return null;
    }
  }
}
