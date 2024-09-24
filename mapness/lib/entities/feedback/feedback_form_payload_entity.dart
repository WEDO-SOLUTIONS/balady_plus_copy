import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/entities/feedback/feedback_field_payload_entity.dart';

part 'feedback_form_payload_entity.freezed.dart';

@freezed
class FeedbackFormPayloadEntity with _$FeedbackFormPayloadEntity {
  const factory FeedbackFormPayloadEntity({
    required String category,
    required int objectId,
    required IList<FeedbackFieldPayloadEntity> fields,
  }) = _FeedbackFormPayloadEntity;
}
