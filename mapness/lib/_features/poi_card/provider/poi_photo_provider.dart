import 'package:dio/dio.dart';
import 'package:mapness/_features/poi_card/domain/dto/dgis_photos_dto.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/base_dio.dart';
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

    /// Ручка без пагинации, данных может быть много, поэтому отменяем запрос при диспозе
    final cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel);
    final response = await dio.get(
      'https://api.photo.urbi.ae/3.0/objects/$objectId/albums/all/photos',
      queryParameters: {
        'key': 'eTei6feebievaeh',
        'locale': switch (locale) {
          Language.english => 'en_SA',
          Language.arabic => 'ar_AE',
        },
        'previewSize': '100x100',
      },
      cancelToken: cancelToken,
    );
    final data = DgisPhotosDto.fromJson(response.data as Map<String, dynamic>);
    return data;
  }
}
