import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/entities/feedback/dto/feedback_schedule_payload_dto.dart';
import 'package:mapness/shared/lib/weekday_entity.dart';

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

  /// Dart's type system has a limitation where generics are implicitly treated as dynamic,
  /// lacking strict constraints on transformations. A more robust solution may exist,
  /// and suggestions for improvement are welcomed.
  ///
  /// In current implemetation this breaks layers hierarhy since domain layer
  /// know regarding serialisation for DTOs.
  //
  // TODO(Demezy): find a way to fix it.
  dynamic valueToJson();
}
