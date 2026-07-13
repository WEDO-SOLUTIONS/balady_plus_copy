import 'package:mapness/entities/city_contain/dto/location_point.dart';
import 'package:mapness/features/trending/data/trending_data_source.dart';

class MockTrendingDataSource implements TrendingDataSource {
  @override
  Future<List<String>> getTrendingItemIds({
    LocationPoint? location,
    int pageSize = 7,
    int page = 1,
  }) async => [
    '70030077059636897',
    '70030077059635032',
    '30681456363397866',
    '30681456363389170',
    '70030077059625553',
  ];
}
