import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as pb;
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/entities/iwish/models/iwish_feedback_entity.dart';
import 'package:mapness/features/iwish/lib/iwish_object_mapper.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iwish_entity.g.dart';
const mapLayerName = 'iwish-entity-markers';
const _markerPrefix = 'iwish-marker-';

@riverpod
class _IwishEntity extends _$IwishEntity {
  void refresh() {
    ref.invalidateSelf();
  }

  Future<bool> submitFeedback(IwishFeedbackEntity feedback) async {
    final request = pb.IWishFeedbackRequest(
      rating: feedback.mood?.index ?? -1 + 1,
      tags: feedback.tags.map((e) => pb.IWishFeedbackRequest_Tag(name: e)),
      text: feedback.comment,
    );

    try {
      final dio = ref.read(dGisNetworkProvider);
      final raw = await dio.post(
        '/iwish/$iwishId/feedback',
        data: request.writeToBuffer(),
      );
      final response = pb.IWishItemResponse.fromBuffer(raw.data);
      state = AsyncData(response.object.toDomain());
      return true;
    } on DioException catch (e) {
      if (kDebugMode) {
        final error = pb.ErrorResponse.fromBuffer(e.response?.data);
        print(error.toDebugString());
      }
    }
    return false;
  }

  @override
  Future<IwishEntity> build(String iwishId) async {
    final dio = ref.watch(dGisNetworkProvider);
    final raw = await dio.get('iwish/$iwishId');

    final response = pb.IWishItemResponse.fromBuffer(raw.data).object;
    print(response.toProto3Json());

    final mapObjectManager =
    ref.watch(mapObjectManagerProvider(named:mapLayerName).notifier);
    var point = response.location.point;
    // final cameraController = ref.watch(cameraPositionProvider.notifier);
    // await cameraController.animateTo(
    //   CameraPositionMessage(
    //     point: GeoPointMessage(
    //       latitude: point.latitude,
    //       longitude: point.longitude,
    //     ),
    //     zoom: 15,
    //     tilt: 0,
    //     bearing: 0,
    //   ),
    // );
    final markerId = '$_markerPrefix${response.id}';
    await mapObjectManager.addMarker(
      Marker(
        id: markerId,
        options: MarkerOptionsMessage(
          position: GeoPointWithElevationMessage(
            latitude: point.latitude,
            longitude: point.longitude,
            elevation: 1,
          ),
          icon: MarkerIconMessage(
            path: "packages/mapness/assets/icons/svg/ic_pin.svg",
            width: 24,
          ),
          anchor: MarkerAnchorMessage(x: 0.5, y: 1.5),
          animatedAppearance: true,
        ),
      ),
    );
    return response.toDomain();
  }
}

const iwishEntityProvider = _iwishEntityProvider;
