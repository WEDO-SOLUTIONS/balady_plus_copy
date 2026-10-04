import 'dart:async';

import 'package:mapness/features/discover/data/bytedance/bytedance_discover_data_source.dart';
import 'package:mapness/features/discover/data/discover_data_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'discover.g.dart';

@riverpod
DiscoverDataSource _discoverDataSource(Ref ref) => BytedanceDiscoverDataSource(ref);

@riverpod
class Discover extends _$Discover {
  @override
  Future<List<String>> build() => ref.read(_discoverDataSourceProvider).getDiscoverItems();
}
