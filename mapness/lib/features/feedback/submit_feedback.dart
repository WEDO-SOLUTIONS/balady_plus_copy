import 'package:mapness/entities/feedback/dto/feedback_form_payload_dto.dart';
import 'package:mapness/entities/feedback/feedback_form_payload_entity.dart';
import 'package:mapness/features/feedback/feedback_dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urbi_analytics/logger.dart';

part 'submit_feedback.g.dart';

@riverpod
Future<void> postFeedback(
  AutoDisposeFutureProviderRef ref,
  FeedbackFormPayloadEntity payload,
) async {
  final dio = await ref.read(feedbackDioProvider.future);
  final response = await dio.post(
    '/api/1.0/discrepancy',
    data: FeedbackFormPayloadDto.fromDomain(payload).toJson(),
  );
  log(response.data.toString());
}
