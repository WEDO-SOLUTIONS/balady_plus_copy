import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mapness/features/poi_card/domain/dto/dgis_photos_dto.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poi_photo_provider.g.dart';

@riverpod
class PoiPhoto extends _$PoiPhoto {
  // TODO(someone): some day, if we would reuse this provider, we should replace dto with
  //  some domain model
  @override
  Future<DgisPhotosDto> build(int objectId) async {
    final dio = ref.watch(baseDioProvider);
    final locale = ref.watch(appLanguageProvider);
    final env = await ref.watch(dgisEnvironmentProvider.future);

    final baseApiUrl = env.baseApiDomain;

    /// Ручка без пагинации, данных может быть много, поэтому отменяем запрос при диспозе
    final cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel);

    final response = await dio.get(
      'https://api.photo.$baseApiUrl/3.0/objects/$objectId/albums/all/photos',
      queryParameters: {
        'key': 'eTei6feebievaeh',
        'locale': switch (locale) {
          Language.english => 'en_SA',
          Language.arabic => 'ar_AE',
        },
        'preview_size': '600x',
      },
      options: Options(
        validateStatus: (status) => status != null && status >= 200 && status < 300 || status == HttpStatus.notFound,
      ),
      cancelToken: cancelToken,
    );

    if (response.statusCode == HttpStatus.notFound) {
      return DgisPhotosDto(albums: [], items: []);
    }

    final data = DgisPhotosDto.fromJson(response.data as Map<String, dynamic>);

    return data;
  }
}
