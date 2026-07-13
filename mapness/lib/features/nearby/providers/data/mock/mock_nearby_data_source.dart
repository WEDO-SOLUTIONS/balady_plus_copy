import 'package:mapness/features/nearby/providers/data/nearby_data_source.dart';

class MockNearbyDataSource extends NearbyDataSource {
  @override
  Future<List<String>> getNearbyItemIds() async => [
    '70030076746444267',
    '70030076411768037',
    '70030076713743168',
    '70030076713206674',
    '70030076713082297',
  ];
}
