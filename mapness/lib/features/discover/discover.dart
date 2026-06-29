import 'dart:async';

import 'package:mapness/features/debug/recommendations_feature_flag.dart';
import 'package:mapness/features/discover/data/discover_data_source.dart';
import 'package:mapness/features/discover/data/mock/mock_discover_data_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'discover.g.dart';

@riverpod
DiscoverDataSource _discoverDataSource(Ref ref) => MockDiscoverDataSource();

@riverpod
class Discover extends _$Discover {
  @override
  Future<List<String>> build() async {
    final recommendationsEnabled = ref.watch(recommendationsFeatureFlagProvider);
    if (!recommendationsEnabled) {
      return [];
    }

    return ref.read(_discoverDataSourceProvider).getDiscoverItems();
  }
}
