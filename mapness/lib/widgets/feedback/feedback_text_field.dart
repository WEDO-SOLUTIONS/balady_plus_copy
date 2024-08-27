import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FeedbackInput extends StatelessWidget {
  final void Function(String) onValueChange;
  final FeedbackTextEntity field;

  const FeedbackInput({
    required this.onValueChange,
    required this.field,
    super.key,
  });

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    final keyboardType = switch (field.type) {
      FeedbackTextType.multilineText => TextInputType.multiline,
      FeedbackTextType.phone => TextInputType.phone,
      FeedbackTextType.url => TextInputType.url,
      FeedbackTextType.text => TextInputType.text,
      FeedbackTextType.email => TextInputType.emailAddress,
    };

    final allowedInputPattern = switch (field.type) {
      FeedbackTextType.email => RegExp(r'[a-zA-Z0-9._%+-@]'),
      FeedbackTextType.phone => RegExp(r'[0-9]'),
      FeedbackTextType.url => RegExp(r'[a-zA-Z0-9./:?_-]'),
      _ => null,
    };

    return BaladyInput(
      labelText: field.label,
      hintText: field.hint,
      labelStyle: context.textStyleV3.captionMediumRegular,
      initialValue: field.value,
      fillColor: context.colorsV2.backgroundSurface1,
      onValidate: (value) => _maybeValidationError(context.l10n, value),
      allowedInputPattern: allowedInputPattern,
      isRequired: field.isRequired,
      maxLength: field.maxLenght,
      keyboardType: keyboardType,
      maxLines: field.type == FeedbackTextType.multilineText ? 5 : 1,
      onChanged: (value) {
        onValueChange(value);
      },
    );
  }

  String? _maybeValidationError(AppLocalizations l10n, String? value) {
    if (field.isStringValid()) {
      return null;
    }
    return l10n.feedbackTextFieldWrongFormat;
  }
}
