import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/feedback/fields_entity/feedback_text_type_entity.dart';
import 'package:mapness/shared/utils/text_utils/phone_number_formatter.dart';

/// A stateless widget that provides a customizable text input field for feedback purposes.
///
/// The widget also applies input formatters based on the [type] parameter.
/// If the [type] is [FeedbackTextType.phone] it applies the [PhoneNumberFormatter] to format the input as a phone number
/// And handle onChanged with formatt input value as pure phone number.

class FeedbackTextInput extends StatelessWidget {
  const FeedbackTextInput({
    required this.labelText,
    required this.hintText,
    required this.isRequired,
    required this.maxLength,
    required this.type,
    this.maxLines = 1,
    this.allowedInputPattern,
    this.keyboardType,
    this.onChanged,
    this.onValidate,
    super.key,
  });

  final String hintText;
  final String? labelText;
  final Pattern? allowedInputPattern;
  final bool isRequired;
  final int maxLength;
  final int maxLines;
  final FeedbackTextType type;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? onValidate;

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: type == FeedbackTextType.phone ? TextDirection.ltr : Directionality.of(context),
        child: BaladyInput(
          labelText: labelText,
          hintText: hintText,
          labelStyle: context.textStyleV3.captionMediumRegular,
          fillColor: context.colorsV2.backgroundSurface1,
          onValidate: onValidate,
          allowedInputPattern: allowedInputPattern,
          isRequired: isRequired,
          maxLength: maxLength,
          maxLines: maxLines,
          keyboardType: keyboardType,
          suffixIcon: type == FeedbackTextType.phone ? const SizedBox.shrink() : null,
          onChanged: (value) {
            var formattedValue = value;
            if (type == FeedbackTextType.phone) {
              formattedValue = PhoneNumberFormatter.formatPure(formattedValue);
            }
            onChanged?.call(value);
          },
          inputFormatters: [
            if (type == FeedbackTextType.phone) const PhoneNumberFormatter(),
          ],
        ),
      );
}
