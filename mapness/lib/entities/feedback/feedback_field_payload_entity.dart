import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_field_payload_entity.freezed.dart';

@freezed
class FeedbackFieldPayloadEntity<T> with _$FeedbackFieldPayloadEntity<T> {
  const factory FeedbackFieldPayloadEntity({
    required String fieldId,

    /// Note: value should be already serialized or whatever, be ready to be used by JsonSerializable.
    /// Dart sucks in generics, so just do not pass something bad, pls
    required T value,
  }) = _FeedbackFieldPayloadEntity<T>;
}
