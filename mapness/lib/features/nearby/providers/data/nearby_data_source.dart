import 'package:mapness/entities/city_contain/dto/location_point.dart';

abstract class NearbyDataSource {
  Future<List<String>> getNearbyItemIds({
    LocationPoint? location,
    int pageSize = 7,
    int page = 1,
  });
}
