import 'package:balady_uikit/balady_uikit.dart' show Spacing;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/balady_uikit/components/text_input/models/src/supporting_text.dart';
import 'package:urbi_utils/urbi_utils.dart';

class BaladyInputSupportingText extends StatelessWidget {
  final TextEditingController controller;
  final BaladySupportingText config;
  final bool isError;

  const BaladyInputSupportingText({
    required this.controller,
    required this.config,
    this.isError = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorSupported = isError ? context.colors.errorDefault : context.colors.foregroundMuted;
    Color? colorMaxLength;
    if (config.maxLength != null) {
      colorMaxLength =
          controller.text.length > config.maxLength! ? context.colors.errorDefault : context.colors.foregroundMuted;
    }

    final hasText = config.text != null;
    final hasMaxLength = config.maxLength != null;

    if (!hasText && !hasMaxLength) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: Spacing.$2x),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (hasText)
            Expanded(
                child: Text(
              config.text!,
              style: config.style ?? context.textStyles.bodySmallRegular.copyWith(color: colorSupported),
              maxLines: 2,
            )),
          if (hasMaxLength)
            Text(
              '${controller.text.length}/${config.maxLength!.toString()}',
              style: config.style ?? context.textStyles.bodySmallRegular.copyWith(color: colorMaxLength),
              maxLines: 2,
              textAlign: TextAlign.end,
            ),
        ].insertBetween(Spacing.$3x.widthBox).toList(),
      ),
    );
  }
}
