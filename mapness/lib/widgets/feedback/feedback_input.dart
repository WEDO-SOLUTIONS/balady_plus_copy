import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';

class FeedbackInput extends StatelessWidget {
  final String? initialValue;
  final String label;
  final String? hintText;
  final void Function(String)? onChanged;
  const FeedbackInput({required this.label, super.key, this.initialValue, this.hintText, this.onChanged});

  @override
  Widget build(BuildContext context) => BaladyInput(
        labelText: label,
        hintText: hintText,
        labelStyle: context.textStyleV3.captionMediumRegular,
        initialValue: initialValue,
        fillColor: context.colorsV2.backgroundSurface1,
        onChanged: onChanged,
      );
}
