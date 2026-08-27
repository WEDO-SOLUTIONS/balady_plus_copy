import 'package:mapness/features/trending/data/trending_data_source.dart';

class MockTrendingDataSource extends TrendingDataSource {
  @override
  Future<List<String>> getTrendingItemIds() async => [
    '70030077059636897',
    '70030077059635032',
    '30681456363397866',
    '30681456363389170',
    '70030077059625553',
  ];
}
