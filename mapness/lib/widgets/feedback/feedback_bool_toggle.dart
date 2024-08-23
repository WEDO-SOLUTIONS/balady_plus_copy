import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class FeedbackBoolToggle extends StatelessWidget {
  final String label;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool) onChanged;
  final bool value;

  const FeedbackBoolToggle({
    required this.onChanged,
    required this.value,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(color: context.colorsV2.borderMuted, width: 1);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.$4x),
      decoration: BoxDecoration(border: Border(bottom: border, top: border)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.textStyleV3.bodyLargeRegular,
            ),
          ),
          Toggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
