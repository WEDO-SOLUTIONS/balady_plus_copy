// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/fields_entity/feedback_text_type_entity.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

part 'feedback_base_dto.g.dart';

part '../fields_dto/feedback_bool_toggle_dto.dart';
part '../fields_dto/feedback_image_input_dto.dart';
part '../fields_dto/feedback_text_dto.dart';
part '../fields_dto/feedback_unknown_dto.dart';
part '../fields_dto/feedback_chips_dto.dart';
part '../fields_dto/feedback_schedule_dto.dart';
part '../fields_dto/feedback_chips_item_dto.dart';
part '../fields_dto/feedback_list_text_dto.dart';

sealed class FeedbackBaseDto {
  final String id;
  final String type;
  final bool isRequired;
  final bool isHidden;
  final bool? setOnMap;

  const FeedbackBaseDto({
    required this.id,
    required this.type,
    required this.setOnMap,
    required this.isRequired,
    required this.isHidden,
  });

  /// Factory method to create the appropriate DTO based on the type
  factory FeedbackBaseDto.fromJson(Map<String, dynamic> json) {
    try {
      return switch (json['type']) {
        'boolean' => FeedbackBoolToggleDto.fromJson(json),
        'list_singleline' => FeedbackTextListDto.fromJson(json),
        'email' || 'multiline' || 'phone' || 'url' || 'singleline' => FeedbackTextDto.fromJson(json),
        'image' => FeedbackImageInputDto.fromJson(json),
        'schedule' => FeedbackScheduleDto.fromJson(json),
        'dropdown' => FeedbackChipsDto.fromJson(json),
        _ => FeedbackUnknownDto.fromJson(json),
      };
    } catch (e) {
      // TODO(Demezy): remove this when fully update to v2.0 endpoints
      logger
        ..log('Error creating FeedbackBaseDto fromJson: ${e.toString()}', logLevel: MapnessLogLevel.critical)
        ..log('json: ${json.toString()}', logLevel: MapnessLogLevel.critical);
      log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      log(e.toString());
      log('+++++++++++++++++++++++++++++++++++++++++++++++++++++');
      log(json.toString());
      log('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
      return FeedbackUnknownDto.fromJson(json);
    }
  }

  /// define protocol for converting to domain
  FeedbackBaseEntity toDomain();
}
