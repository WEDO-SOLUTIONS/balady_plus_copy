import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/features/nearby/model/nearby_model.dart';
import 'package:mapness/features/nearby/providers/data/bytedance/bytedance_nearby_data_source.dart';
import 'package:mapness/features/nearby/providers/data/mock/mock_nearby_data_source.dart';
import 'package:mapness/features/nearby/providers/data/nearby_data_source.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nearby.g.dart';

@riverpod
NearbyDataSource _nearbyDataSource(Ref ref) => BytedanceTrendingDataSource(ref);

@riverpod
class Nearby extends _$Nearby {
  @override
  Future<List<NearbyItemData>> build() async {
    final intIds = await ref.read(nearbyIdsProvider.future);
    return Future.wait(intIds.map((id) => ref.read(nearbyItemProvider(id).future)));
  }
}

@riverpod
class NearbyIds extends _$NearbyIds {
  @override
  Future<List<int>> build() async {
    final ids = await ref.read(_nearbyDataSourceProvider).getNearbyItemIds();
    return ids.map((e) => int.tryParse(e)).nonNulls.toList();
  }
}

@riverpod
class NearbyItem extends _$NearbyItem {
  @override
  Future<NearbyItemData> build(int objectId) async {
    final dgisController = ref.read(dgisControllerProvider).value;
    if (dgisController == null) {
      throw Exception('dgisController is null');
    }

    final object = await dgisController.searchByObjectId(DgisObjectIdMessage(objectId: objectId, entranceId: 0));
    return NearbyItemData(object: object);
  }
}
