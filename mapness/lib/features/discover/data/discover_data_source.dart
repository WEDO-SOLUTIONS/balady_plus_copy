import 'package:mapness/entities/city_contain/dto/location_point.dart';

abstract class DiscoverDataSource {
  Future<List<String>> getDiscoverItems({
    LocationPoint? location,
    int pageSize = 7,
    int page = 1,
  });
}
