import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_field_payload_entity.freezed.dart';

@freezed
class FeedbackFieldPayloadEntity with _$FeedbackFieldPayloadEntity {
  const factory FeedbackFieldPayloadEntity({
    required String fieldId,

    /// Actually idk how to do it properly with generics in dart, since type checker
    /// does not care about types, runtyme errors lmao. So why should I?
    ///
    /// Rule is ignored because freezed sucks to generate otherwise but I want it to be required
    // ignore: avoid_annotating_with_dynamic
    required dynamic value,
  }) = _FeedbackFieldPayloadEntity;
}
