import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextFieldWidget;

class PhoneNumberField extends StatelessWidget {
  final bool readOnly;
  final bool isRequired;
  final int maxLength;
  final String? initialValue;
  final String? label;
  final String? hint;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final String? errorText;
  final void Function(String)? onChanged;
  const PhoneNumberField({
    super.key,
    this.readOnly = false,
    this.isRequired = true,
    this.maxLength = 10,
    this.initialValue,
    this.label,
    this.hint,
    this.textInputAction,
    this.prefixIcon,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFieldWidget(
      initialValue: initialValue,
      label: label ?? fieldLabel,
      hintText: hint ?? label ?? fieldHint,
      readOnly: readOnly,
      isRequired: isRequired,
      isDigitsOnly: true,
      maxLength: maxLength,
      autofillHints: const [AutofillHints.telephoneNumber],
      keyboardType: TextInputType.number,
      textInputAction: textInputAction ?? TextInputAction.next,
      prefixIcon: prefixIcon,
      errorText: errorText,
      onChanged: onChanged,
    );
  }

  String get fieldLabel => "phoneNumber".tr();
  String get fieldHint => "enter ".tr() + fieldLabel;
}
