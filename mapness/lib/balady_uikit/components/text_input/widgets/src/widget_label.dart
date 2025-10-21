// ignore_for_file: prefer_expression_function_bodies

import 'package:balady_uikit/balady_uikit.dart' hide BaladyInputLabel;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/balady_uikit/components/text_input/models/input_models.dart';

class WidgetLabel extends StatelessWidget {
  final BaladyInputLabel label;

  const WidgetLabel({
    required this.label,
    super.key,
  });

  static const double littlePadding = 8.0;

  @override
  Widget build(BuildContext context) {
    // There was AutoSizeText and do we need it here?
    // if field is required, then show label beside asterisk e.g. Username*
    final defaultStyle = context.textStyles.captionMediumRegular.copyWith(color: context.colors.foregroundDefault);
    final textStyle = label.style ?? defaultStyle;
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: labelPadding,
            child: RichText(
              text: TextSpan(
                text: label.text,
                style: textStyle,
                children: [
                  if (label.isRequired)
                    TextSpan(
                      text: '*',
                      style: textStyle.copyWith(color: context.colors.errorDefault),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  EdgeInsetsGeometry get labelPadding => label.padding ?? const EdgeInsets.only(bottom: Spacing.$2x);
}
