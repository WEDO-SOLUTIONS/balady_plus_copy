import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/entities/feedback/feedback_icon.dart';

part 'fields_entity/feedback_bool_toggle_entity.dart';
part 'fields_entity/feedback_text_entity.dart';
part 'fields_entity/feedback_image_input_entity.dart';
part 'fields_entity/feedback_unknown_entity.dart';
part 'fields_entity/feedback_chips_entity.dart';
part 'fields_entity/feedback_schedule_entity.dart';

sealed class FeedbackBaseEntity<T> {
  final String id;
  final bool isRequired;
  final bool isHidden;
  final T? value;

  bool get isValid => !isRequired || value != null;

  const FeedbackBaseEntity({
    required this.id,
    required this.isRequired,
    required this.isHidden,
    required this.value,
  });

  FeedbackBaseEntity<T> updatedValue(T value);
}
