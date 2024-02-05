import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as pb;
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/entities/iwish/models/iwish_feedback_entity.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/iwish/lib/iwish_object_mapper.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iwish_entity.g.dart';

@riverpod
class _IwishEntity extends _$IwishEntity {
  void refresh() {
    ref.invalidateSelf();
  }

  Future<bool> submitFeedback(IwishFeedbackEntity feedback) async {
    ref
        .read(urbiMetricsProvider.notifier)
        .logEvent('IwishFeedbackEntity/submitFeedback', {
      'feedback': feedback.mood.toString(),
      'tags': feedback.tags.toString(),
      'comment': feedback.comment,
    });
    mixpanel?.timeEvent('IwishFeedbackEntity: submitFeedback');
    final dio = await ref.read(dGisNetworkProvider.future);
    final request = pb.IWishFeedbackRequest(
      rating: feedback.mood?.index ?? -1 + 1,
      tags: feedback.tags.map((e) => pb.IWishFeedbackRequest_Tag(name: e)),
      text: feedback.comment,
    );

    try {
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
    mixpanel?.track('IwishFeedbackEntity: submitFeedback');
    return false;
  }

  @override
  Future<IwishEntity> build(String iwishId) async {
    final dio = await ref.read(dGisNetworkProvider.future);

    final raw = await dio.get('iwish/$iwishId');

    final response = pb.IWishItemResponse.fromBuffer(raw.data).object;
    debugPrint('${response.toProto3Json()}');

    final mapObjectManager =
        ref.watch(mapObjectManagerProvider(named: MapnessConsts.mapLayerName).notifier);
    final point = response.location.point;
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
    await mapObjectManager.addMarker(
      Markers.pinMarker(
        GeoPointWithElevationMessage(
          latitude: point.latitude,
          longitude: point.longitude,
          elevation: 1,
        ),
      ),
    );
    return response.toDomain();
  }
}

const iwishEntityProvider = _iwishEntityProvider;
