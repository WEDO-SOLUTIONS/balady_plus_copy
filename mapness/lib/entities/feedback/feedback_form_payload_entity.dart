import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/entities/feedback/feedback_field_payload_entity.dart';
import 'package:mapness/entities/feedback/feedback_object_type.dart';

part 'feedback_form_payload_entity.freezed.dart';

@freezed
class FeedbackFormPayloadEntity with _$FeedbackFormPayloadEntity {
  const factory FeedbackFormPayloadEntity({
    required FeedbackObjectType category,
    required IList<FeedbackFieldPayloadEntity> fields,
    required double latitude,
    required double longitude,
    required String objectId,
    required String objectType,
    required String userEmail,
  }) = _FeedbackFormPayloadEntity;
}
