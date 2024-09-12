import 'package:mapness/entities/feedback/dto/feedback_form_payload_dto.dart';
import 'package:mapness/entities/feedback/feedback_form_payload_entity.dart';
import 'package:mapness/entities/feedback/feedback_object_type.dart';
import 'package:mapness/features/feedback/feedback_dio.dart';
import 'package:mapness/features/feedback/poi_feedback.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urbi_analytics/logger.dart';

part 'submit_feedback.g.dart';

@riverpod
Future<void> submitFeedback(
  AutoDisposeFutureProviderRef ref,
  FeedbackFormPayloadEntity payload,
) async {
  final userInfo = await ref.watch(authProvider.future);
  final poiInfo = await ref.read(poiFeedbackProvider(payload.objectId).future);
  final dio = await ref.read(feedbackDioProvider.future);

  if (poiInfo == null) {
    throw Exception('POI info not found');
  }

  final latitude = poiInfo.markerPosition?.latitude;
  final longitude = poiInfo.markerPosition?.longitude;

  if (latitude == null || longitude == null) {
    throw Exception('Unknown POI position');
  }

  final response = await dio.post(
    '/api/1.0/discrepancy',
    data: FeedbackFormPayloadDto.fromDomain(
      entity: payload,
      userEmail: userInfo?.getEmail(),
      latitude: latitude,
      longitude: longitude,
      objectType: FeedbackObjectType.fromMessage(poiInfo.types.firstOrNull?.type),
    ).toJson(),
  );
  log(response.data.toString());
}
