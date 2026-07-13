import 'package:mapness/entities/city_contain/dto/location_point.dart';

abstract class TrendingDataSource {
  Future<List<String>> getTrendingItemIds({
    LocationPoint? location,
    int pageSize = 7,
    int page = 1,
  });
}
