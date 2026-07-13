import 'package:mapness/entities/city_contain/dto/location_point.dart';
import 'package:mapness/features/nearby/providers/data/nearby_data_source.dart';

class MockNearbyDataSource implements NearbyDataSource {
  @override
  Future<List<String>> getNearbyItemIds({
    LocationPoint? location,
    int pageSize = 7,
    int page = 1,
  }) async => [
    '70030076746444267',
    '70030076411768037',
    '70030076713743168',
    '70030076713206674',
    '70030076713082297',
  ];
}
