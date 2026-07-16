import 'package:mapness/features/discover/data/discover_data_source.dart';

class MockDiscoverDataSource extends DiscoverDataSource {
  @override
  Future<List<String>> getDiscoverItems() async => [
    'riyadh park',
    'Model Plan Park',
    'Coffee',
    'mosque near me',
    'cafe near me',
    'restaurant near me',
    'pharmacy',
  ];
}
