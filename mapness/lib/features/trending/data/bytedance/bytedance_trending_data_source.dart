import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/entities/city_contain/dto/location_point.dart';
import 'package:mapness/features/app_feedback/device_info_provider.dart';
import 'package:mapness/features/discover/data/discover_data_source.dart';
import 'package:mapness/features/trending/data/trending_data_source.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/bytedance_dio.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:rangers_applog_flutter_plugin/rangers_applog_flutter_plugin.dart';

part 'bytedance_trending_data_source.freezed.dart';
part 'bytedance_trending_data_source.g.dart';
part 'dto.dart';

class BytedanceTrendingDataSource implements TrendingDataSource {
  final Ref ref;

  const BytedanceTrendingDataSource(this.ref);

  @override
  Future<List<String>> getTrendingItemIds({
    LocationPoint? location,
    int pageSize = 7,
    int page = 1,
  }) async {
    final dio = await ref.read(bytedanceDioProvider.future);
    final appLanguage = ref.read(appLanguageProvider);
    final deviceInfo = await ref.read(deviceInfoProvider.future);

    final String locationString;
    if (location != null) {
      locationString = '${location.longitude},${location.latitude}';
    } else {
      final location = await ref.read(getLocationSyncProvider().future);
      locationString = '${location.longitude},${location.latitude}';
    }

    final response = await dio.post(
      '/v1/search/trends',
      data: <String, dynamic>{
        'userid': CommonProperties.userInfo?.idNo,
        'deviceid': deviceInfo.deviceId ?? 'NO_DEVICE_ID',
        'ssid': await RangersApplogFlutterPlugin.getSsid(),
        'location': locationString,
        'locale': appLanguage == Language.arabic ? 'ar_SA' : 'en_SA',
        'page': page,
        'page_size': pageSize,
      },
    );

    final data = response.data;
    final result = BytedanceTrendingResponse.fromJson(data);
    return result.items.map((e) => e.id).toList();
  }
}
