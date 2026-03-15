import 'package:dio/dio.dart';
import 'package:mapness/entities/makkah_bus/makkah_bus_departures_model.dart';
import 'package:mapness/features/makkah_bus/providers/makkah_bus_dio_provider.dart';
import 'package:mapness/shared/providers/app_language.dart' show appLanguageProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/providers/app_language.dart' show appLanguageProvider, LanguageData;

part 'makkah_bus_repository.g.dart';

@riverpod
class MakkahBusRepository extends _$MakkahBusRepository {
  @override
  void build() {}

  Future<MakkahBusDeparturesResponse?> getDepartures(String poiId) async {
    try {
      final dio = await ref.read(makkahBusDioProvider.future);
      final appLanguage = ref.read(appLanguageProvider);
      final response = await dio.get(
        '$poiId/departures',
        options: Options(responseType: ResponseType.json),
        queryParameters: {
          'locale':appLanguage.languageCode
        }
      );
      final data = response.data;
      if (data == null) {
        return null;
      }
      return MakkahBusDeparturesResponse.fromJson(data);
    } on DioException catch (_) {
      return null;
    } catch (e) {
      return null;
    }
  }
}
