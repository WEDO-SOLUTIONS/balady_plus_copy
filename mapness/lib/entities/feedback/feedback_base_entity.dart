import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/entities/feedback/fields_entity/feedback_text_type_entity.dart';
import 'package:mapness/shared/lib/weekday_entity.dart';

part 'fields_entity/feedback_bool_toggle_entity.dart';
part 'fields_entity/feedback_chips_entity.dart';
part 'fields_entity/feedback_image_input_entity.dart';
part 'fields_entity/feedback_schedule_entity.dart';
part 'fields_entity/feedback_text_entity.dart';
part 'fields_entity/feedback_unknown_entity.dart';
part 'fields_entity/feedback_text_list_entity.dart';

part 'feedback_base_entity.freezed.dart';

sealed class FeedbackBaseEntity {
  final String id;
  final bool isRequired;
  final bool isHidden;

  const FeedbackBaseEntity({
    required this.id,
    required this.isRequired,
    required this.isHidden,
  });
}
