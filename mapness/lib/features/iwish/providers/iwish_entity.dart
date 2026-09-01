import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as pb;
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/entities/iwish/models/iwish_feedback_entity.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/iwish/lib/iwish_object_mapper.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iwish_entity.g.dart';

const iwishPinId = 'iwish_pin_id';

@riverpod
class _IwishEntity extends _$IwishEntity {
  void refresh() {
    ref.invalidateSelf();
  }

  Future<bool> submitFeedback(IwishFeedbackEntity feedback) async {
    mixpanel?.timeEvent('IwishFeedbackEntity: submitFeedback');
    final dio = await ref.read(dGisNetworkProvider.future);
    final request = pb.IWishFeedbackRequest(
      rating: feedback.mood != null ? pb.IWishFeedbackRating.values[feedback.mood!.index] : null,
      tags: feedback.tags.map((e) => pb.IWishFeedbackRequest_Tag(name: e)),
      text: feedback.comment,
    );

    try {
      final raw = await dio.post('/iwish/$iwishId/feedback', data: request.writeToBuffer());
      final response = pb.IWishItemResponse.fromBuffer(raw.data as List<int>);
      state = AsyncData(response.object.toDomain());
      return true;
    } on DioException catch (e) {
      if (kDebugMode) {
        final error = pb.ErrorResponse.fromBuffer(e.response?.data as List<int>);
        logger.log(error.toDebugString(), logLevel: MapnessLogLevel.critical);
      }
    }
    await mixpanel?.track('IwishFeedbackEntity: submitFeedback');
    return false;
  }

  @override
  Future<IwishEntity> build(String iwishId) async {
    final dio = await ref.read(dGisNetworkProvider.future);
    if (!ref.mounted) {
      throw StateError('iwishEntityProvider disposed');
    }

    final raw = await dio.get('iwish/$iwishId');
    if (!ref.mounted) {
      throw StateError('iwishEntityProvider disposed');
    }

    final response = pb.IWishItemResponse.fromBuffer(raw.data as List<int>).object;
    final point = response.location.point;
    if (kDebugMode) {
      logger.log('${response.toProto3Json()}');
    }
    final isDark = ref.read(darkModeProvider).value?.isDark ?? false;
    final selectedMarker = ref.read(selectedMarkerProvider.notifier);
    final activeCityEvent = ref.read(activeCityEventProvider);
    await selectedMarker.showMarker(
      Markers.pinMarker(
        GeoPointWithElevationMessage(latitude: point.latitude, longitude: point.longitude, elevation: 1),
        id: iwishPinId,
        activeCityEvent: activeCityEvent,
        isDark: isDark,
      ),
    );
    ref.onDispose(() async {
      await selectedMarker.removeMarker(iwishPinId);
    });

    return response.toDomain();
  }
}

final iwishEntityProvider = _iwishEntityProvider;
