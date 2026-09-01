import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';
import 'package:mapness/features/trending/data/bytedance/bytedance_trending_data_source.dart';
import 'package:mapness/features/trending/data/trending_data_source.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'model.dart';

part 'trending.g.dart';

@riverpod
TrendingDataSource _trendingDataSource(Ref ref) => BytedanceTrendingDataSource(ref);

@riverpod
class Trending extends _$Trending {
  @override
  Future<List<TrendingItem>> build() async {
    final ids = await ref.read(_trendingDataSourceProvider).getTrendingItemIds();
    final dgisController = ref.read(dgisControllerProvider).value;
    if (dgisController == null) {
      throw Exception('dgisController is null');
    }

    final intIds = ids.map((e) => int.tryParse(e)).nonNulls;
    final objects = await Future.wait(
      intIds.map((id) async {
        try {
          return await dgisController.searchByObjectId(
            DgisObjectIdMessage(objectId: id, entranceId: 0),
          );
        } catch (error) {
          logger.log(error.toString(), logLevel: MapnessLogLevel.warning);
          return null;
        }
      }),
    );

    return objects.nonNulls.map((e) => TrendingItem(object: e)).toList();
  }
}
