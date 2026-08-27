import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';
import 'package:mapness/features/debug/recommendations_feature_flag.dart';
import 'package:mapness/features/trending/data/mock/mock_trending_data_source.dart';
import 'package:mapness/features/trending/data/trending_data_source.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'model.dart';
part 'trending.g.dart';

@riverpod
TrendingDataSource _trendingDataSource(Ref ref) => MockTrendingDataSource();

@riverpod
class Trending extends _$Trending {
  @override
  Future<List<TrendingItem>> build() async {
    final recommendationsEnabled = ref.watch(recommendationsFeatureFlagProvider);
    if (!recommendationsEnabled) {
      return [];
    }

    final ids = await ref.read(_trendingDataSourceProvider).getTrendingItemIds();
    final dgisController = ref.read(dgisControllerProvider).value;
    if (dgisController == null) {
      throw Exception('dgisController is null');
    }

    final intIds = ids.map((e) => int.tryParse(e)).nonNulls;
    final objects = await Future.wait(
      intIds.map((id) => dgisController.searchByObjectId(DgisObjectIdMessage(objectId: id, entranceId: 0))),
    );

    return objects.map((e) => TrendingItem(object: e)).toList();
  }
}
