import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mapness/entities/feedback/dto/feedback_form_payload_dto.dart';
import 'package:mapness/entities/feedback/feedback_object_type.dart';
import 'package:mapness/features/feedback/feedback_dio.dart';
import 'package:mapness/features/feedback/poi_feedback.dart';
import 'package:mapness/features/feedback/submit_feedback_payload.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urbi_analytics/logger.dart';

part 'submit_feedback.g.dart';

/// this provider load form state from [submitFeedbackPayloadProvider] because of
/// navigation limitation for data exchange.
@riverpod
Future<void> submitFeedback(
  AutoDisposeFutureProviderRef ref,
  String payloadId,
) async {
  final payload = ref.watch(submitFeedbackPayloadProvider(payloadId));
  final userInfo = await ref.watch(authProvider.future);
  // should not, but if fail than AsyncError state
  final poiInfo = await ref.read(poiFeedbackProvider(payload!.objectId).future);
  final dio = await ref.read(feedbackDioProvider.future);

  if (poiInfo == null) {
    // TODO(Demezy): When app exceptions released, use them instead
    throw Exception('POI info not found');
  }

  final latitude = poiInfo.markerPosition?.latitude;
  final longitude = poiInfo.markerPosition?.longitude;

  if (latitude == null || longitude == null) {
    // TODO(Demezy): When app exceptions released, use them instead
    throw Exception('Unknown POI position');
  }

  try {
    final objectType = FeedbackObjectType.fromMessage(poiInfo.types.firstOrNull?.type);
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
    log(response.data.toString());
  } on DioException catch (e) {
    print(e.response?.statusCode?.toString() ?? '');
    // print(e.toString());
    print('request data: ${jsonEncode(e.requestOptions.data)}');
    print('response data: ${jsonEncode(e.response?.data)}');
    rethrow;
  } catch (e) {
    log(e.toString());
    rethrow;
  }
}
