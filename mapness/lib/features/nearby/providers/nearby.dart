import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/features/nearby/model/nearby_model.dart';
import 'package:mapness/features/nearby/providers/data/mock/mock_nearby_data_source.dart';
import 'package:mapness/features/nearby/providers/data/nearby_data_source.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nearby.g.dart';

@riverpod
NearbyDataSource _nearbyDataSource(Ref ref) => MockNearbyDataSource();

@riverpod
class Nearby extends _$Nearby {
  @override
  Future<List<NearbyItem>> build() async {
    final ids = await ref.read(_nearbyDataSourceProvider).getNearbyItemIds();
    final dgisController = ref.read(dgisControllerProvider).value;
    if (dgisController == null) {
      throw Exception('dgisController is null');
    }

    final intIds = ids.map((e) => int.tryParse(e)).nonNulls;
    final objects = await Future.wait(
      intIds.map((id) => dgisController.searchByObjectId(DgisObjectIdMessage(objectId: id, entranceId: 0))),
    );

    return objects.map((e) => NearbyItem(object: e)).toList();
  }
}
