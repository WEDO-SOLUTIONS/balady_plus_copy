import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';

part 'feedback_base_dto.g.dart';
part '../fields_dto/feedback_bool_toggle_dto.dart';
part '../fields_dto/feedback_text_dto.dart';
part '../fields_dto/feedback_image_input_dto.dart';
part '../fields_dto/feedback_unknown_dto.dart';

sealed class FeedbackBaseDto {
  final String id;
  final String type;
  final bool isRequired;

  FeedbackBaseDto({
    required this.id,
    required this.type,
    required this.isRequired,
  });

  /// trick how to parse by type
  factory FeedbackBaseDto.fromJson(Map<String, dynamic> json) =>
      switch (json['type']) {
        /// bool toggle actually
        'owner' => _$FeedbackBoolToggleDtoFromJson(json),

        /// texts
        'text' ||
        'email' ||
        'multiline' ||
        'phone' ||
        'url' ||
        'singleline' =>
          _$FeedbackTextDtoFromJson(json),

        /// image gallery picker
        'image' => _$FeedbackImageInputDtoFromJson(json),

        /// for future changes
        _ => _$FeedbackUnknownDtoFromJson(json),
      };

  /// define protocol for converting to domain
  FeedbackBaseEntity toDomain();
}
