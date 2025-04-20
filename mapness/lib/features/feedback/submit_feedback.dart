import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/feedback/dto/feedback_form_payload_dto.dart';
import 'package:mapness/entities/feedback/feedback_object_type.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/feedback/feedback_dio.dart';
import 'package:mapness/features/feedback/poi_feedback.dart';
import 'package:mapness/features/feedback/submit_feedback_payload.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urbi_analytics/logger.dart';

part 'submit_feedback.g.dart';

/// this provider load form state from [submitFeedbackPayloadProvider] because of
/// navigation limitation for data exchange.
@riverpod
Future<void> submitFeedback(
  Ref ref,
  String payloadId,
) async {
  final payload = ref.watch(submitFeedbackPayloadProvider(payloadId));
  final userInfo = await ref.watch(authProvider.future);

  double? latitude;
  double? longitude;
  FeedbackObjectType? objectType;

  if (payload == null) {
    throw Exception('Payload not found');
  }

  if (payload.objectId != null) {
    final objectId = payload.objectId!;

    final poiInfo = await ref.read(poiFeedbackProvider(objectId).future);
    if (poiInfo == null) {
      // TODO(Demezy): When app exceptions released, use them instead
      throw Exception('POI info not found');
    }
    latitude = poiInfo.markerPosition?.latitude;
    longitude = poiInfo.markerPosition?.longitude;

    if (latitude == null || longitude == null) {
      // TODO(Demezy): When app exceptions released, use them instead
      throw Exception('Unknown POI position');
    }

    objectType = FeedbackObjectType.fromMessage(poiInfo.types.firstOrNull?.type);
  } else {
    final cameraPosition = ref.read(cameraPositionProvider);
    latitude = cameraPosition?.point.latitude;
    longitude = cameraPosition?.point.longitude;
    if (latitude == null || longitude == null) {
      throw Exception('Unknown POI position');
    }
    // Set default object type
    objectType = FeedbackObjectType.building;
  }

  final dio = await ref.read(feedbackDioProvider.future);

  try {
    final response = await dio.post(
      '/discrepancy',
      data: FeedbackFormPayloadDto.fromDomain(
        entity: payload,
        userEmail: userInfo?.getEmail(),
        latitude: latitude,
        longitude: longitude,
        objectType: objectType,
      ).toJson(),
    );
    ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.poiSubmitted);
    log(response.data.toString());
  } on DioException catch (e) {
    log(e.response?.statusCode?.toString() ?? '');
    // print(e.toString());
    log('request data: ${jsonEncode(e.requestOptions.data)}');
    log('response data: ${jsonEncode(e.response?.data)}');
    rethrow;
  } catch (e) {
    log(e.toString());
    rethrow;
  }
}
