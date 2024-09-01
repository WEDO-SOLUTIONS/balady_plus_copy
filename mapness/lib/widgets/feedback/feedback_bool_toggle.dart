import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';

class FeedbackBoolToggle extends StatelessWidget {
  final FeedbackBoolToggleEntity field;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool) onValueChange;

  const FeedbackBoolToggle({
    required this.field,
    required this.onValueChange,
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
          Toggle(
            value: field.value ?? false,
            onChanged: (state) => onValueChange(state),
          ),
        ],
      ),
    );
  }
}
