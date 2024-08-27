import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/widgets/feedback/feedback_bool_toggle.dart';
import 'package:mapness/widgets/feedback/feedback_images.dart';
import 'package:mapness/widgets/feedback/feedback_text_field.dart';

class FeedbackFieldWidget<V> extends StatelessWidget {
  final FeedbackBaseEntity<V> field;
  final void Function(V) onValueChange;

  const FeedbackFieldWidget({
    required this.field,
    required this.onValueChange,
    super.key,
  });

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return switch (field) {
      FeedbackTextEntity() => FeedbackInput(
          onValueChange: (value) => onValueChange(value as V),
          // wonderful type inference, mmm
          field: field as FeedbackTextEntity,
        ),
      FeedbackBoolToggleEntity() => FeedbackBoolToggle(
          field: field as FeedbackBoolToggleEntity,
          onValueChange: (value) => onValueChange(value as V),
        ),
      FeedbackImageInputEntity() => FeedbackImages(
          field: field as FeedbackImageInputEntity,
          onValueChange: (value) => onValueChange(value as V),
        ),
      _ => Container(
          padding: const EdgeInsets.all(Spacing.$4x),
          color: Colors.red,
          child: const Text('Unknown field'),
        ),
    };
  }
}
