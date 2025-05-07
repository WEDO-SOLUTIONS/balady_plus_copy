import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/widgets/feedback/feedback_bool_toggle.dart';
import 'package:mapness/widgets/feedback/feedback_chips.dart';
import 'package:mapness/widgets/feedback/feedback_schedule_widget.dart';
import 'package:mapness/widgets/feedback/feedback_sub_chips.dart';
import 'package:mapness/widgets/feedback/feedback_text_field.dart';
import 'package:mapness/widgets/feedback/feedback_text_list.dart';
import 'package:mapness/widgets/feedback/images/feedback_images.dart';

/// please note that all widgets shoud be inside [FormBuilder] since it manages state.
/// Dont forget to implement [valueTransformer] for fields with some custom type
class FeedbackFieldWidget extends StatefulWidget {
  final FeedbackBaseEntity field;

  const FeedbackFieldWidget({
    required this.field,
    super.key,
  });

  @override
  State<FeedbackFieldWidget> createState() => _FeedbackFieldWidgetState();
}

class _FeedbackFieldWidgetState extends State<FeedbackFieldWidget> with AutomaticKeepAliveClientMixin {
  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    // TODO(Demezy): figure out how not to typecast. Or blame stupid type system.
    // wonderful type inference, mmm
    super.build(context);
    return switch (widget.field) {
      /// various string inputs like phone, etc
      FeedbackTextEntity() => FeedbackInput(
          key: ValueKey(widget.field.id),
          field: widget.field as FeedbackTextEntity,
        ),

      /// various string inputs like phone, etc
      FeedbackTextListEntity() => FeedbackTextListField(
          key: ValueKey(widget.field.id),
          field: widget.field as FeedbackTextListEntity,
        ),

      /// bool
      FeedbackBoolToggleEntity() => FeedbackBoolToggle(
          key: ValueKey(widget.field.id),
          field: widget.field as FeedbackBoolToggleEntity,
        ),

      /// upload photos
      FeedbackImageInputEntity() => FeedbackImages(
          key: ValueKey(widget.field.id),
          field: widget.field as FeedbackImageInputEntity,
        ),

      /// select one of many
      FeedbackChipsEntity() => FeedbackChips(
          key: ValueKey(widget.field.id),
          field: widget.field as FeedbackChipsEntity,
        ),

      /// working days, breaks, schedule
      FeedbackScheduleEntity() => FeedbackScheduleWidget(
          key: ValueKey(widget.field.id),
          field: widget.field as FeedbackScheduleEntity,
        ),
      FeedbackSubChipsEntity() => FeedbackSubChips(
          key: ValueKey(widget.field.id),
          field: widget.field as FeedbackSubChipsEntity,
        ),

      /// Handle unknown fields (if i.e. backend does not increase api version but change protocol)
      /// since field is required make form invalid
      FeedbackUnknownEntity(isRequired: final isRequired) when isRequired => FormBuilderField<void>(
          name: widget.field.id,

          /// make form invalid
          validator: (_) => 'UNKNOWN_REQUIRED_FIELD',
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
          name: widget.field.id,
          builder: (_) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Spacing.$4x),
              color: Colors.grey,
            ),
            padding: const EdgeInsets.all(Spacing.$4x),
            child: Text('Unknown field but not required - id: ${widget.field.id}'),
          ),
        ),
    };
  }

  @override
  bool get wantKeepAlive => true;
}
