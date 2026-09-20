import 'package:mapness/entities/city_contain/dto/location_point.dart';
import 'package:mapness/features/discover/data/discover_data_source.dart';

class MockDiscoverDataSource implements DiscoverDataSource {
  @override
  Future<List<String>> getDiscoverItems({
    LocationPoint? location,
    int pageSize = 7,
    int page = 1,
  }) async => [
    'riyadh park',
    'Model Plan Park',
    'Coffee',
    'mosque near me',
    'cafe near me',
    'restaurant near me',
    'pharmacy',
  ];
}
