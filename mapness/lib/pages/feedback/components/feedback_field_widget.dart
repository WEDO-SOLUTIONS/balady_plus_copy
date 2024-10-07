import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/widgets/feedback/feedback_bool_toggle.dart';
import 'package:mapness/widgets/feedback/feedback_chips.dart';
import 'package:mapness/widgets/feedback/feedback_images.dart';
import 'package:mapness/widgets/feedback/feedback_schedule_widget.dart';
import 'package:mapness/widgets/feedback/feedback_text_field.dart';

/// please note that all widgets shoud be inside [FormBuilder] since it manages state.
/// Dont forget to implement [valueTransformer] for fields with some custom type
class FeedbackFieldWidget extends StatelessWidget {
  final FeedbackBaseEntity field;

  const FeedbackFieldWidget({
    required this.field,
    super.key,
  });

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    // TODO(Demezy): figure out how not to typecast. Or blame stupid type system.
    // wonderful type inference, mmm
    return switch (field) {
      /// various string inputs like phone, etc
      FeedbackTextEntity() => FeedbackInput(field: field as FeedbackTextEntity),

      /// bool
      FeedbackBoolToggleEntity() => FeedbackBoolToggle(field: field as FeedbackBoolToggleEntity),

      /// upload photos
      FeedbackImageInputEntity() => FeedbackImages(field: field as FeedbackImageInputEntity),

      /// select one of many
      FeedbackChipsEntity() => FeedbackChips(field: field as FeedbackChipsEntity),

      /// working days, breaks, schedule
      FeedbackScheduleEntity() => FeedbackScheduleWidget(field: field as FeedbackScheduleEntity),

      /// Handle unknown fields (if i.e. backend does not increase api version but change protocol)
      /// since field is required make form invalid
      FeedbackUnknownEntity(isRequired: final isRequired) when isRequired => FormBuilderField<void>(
          name: field.id,

          /// make form invalid
          validator: (_) => 'ACHTUNG',
          builder: (_) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Spacing.$4x),
              color: Colors.red,
            ),
            padding: const EdgeInsets.all(Spacing.$4x),
            child: const Text('Unknown required field'),
          ),
        ),

      /// if field is not required, than make it valid
      _ => FormBuilderField<void>(
          name: field.id,
          builder: (_) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Spacing.$4x),
              color: Colors.grey,
            ),
            padding: const EdgeInsets.all(Spacing.$4x),
            child: Text('Unknown field but not required - id: ${field.id}'),
          ),
        ),
    };
  }
}
