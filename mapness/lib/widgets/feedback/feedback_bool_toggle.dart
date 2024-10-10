import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';

class FeedbackBoolToggle extends StatelessWidget {
  final FeedbackBoolToggleEntity field;

  const FeedbackBoolToggle({
    required this.field,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(color: context.colorsV2.borderMuted);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.$4x),
      decoration: BoxDecoration(border: Border(bottom: border, top: border)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              field.label,
              style: context.textStyleV3.bodyLargeRegular,
            ),
          ),
          FormBuilderField<bool>(
            name: field.id,
            initialValue: false,

            /// it should be string, not json boolean, lol. Probably fixed sometime
            valueTransformer: (value) => value.toString(),
            builder: (fieldState) => Toggle(
              value: fieldState.value ?? false,
              onChanged: fieldState.didChange,
            ),
          ),
        ],
      ),
    );
  }
}
