import 'package:dgis_map/library.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/entities/feedback/dto/feedback_field_payload_dto.dart';

part 'feedback_form_payload_entity.freezed.dart';

@freezed
abstract class FeedbackFormPayloadEntity with _$FeedbackFormPayloadEntity {
  const factory FeedbackFormPayloadEntity({
    required String category,
    required IList<FeedbackFieldPayloadDto> fields,
    required VisibleRect viewport,
    int? objectId,
    @Default(false) bool hasPhotos,
  }) = _FeedbackFormPayloadEntity;
}
