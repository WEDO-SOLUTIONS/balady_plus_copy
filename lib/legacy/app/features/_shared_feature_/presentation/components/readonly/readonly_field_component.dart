import 'package:flutter/material.dart';

import '../../../shared_feature_exports.dart' show CustomTextFieldWidget;

class ReadOnlyFieldComponent extends StatelessWidget {
  final String initialValue;
  final String label;
  final Widget? suffixIcon;
  const ReadOnlyFieldComponent({
    super.key,
    required this.initialValue,
    required this.label,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFieldWidget(
      initialValue: initialValue,
      label: label,
      readOnly: true,
      borderColor: Colors.transparent,
      suffixIcon: suffixIcon,
    );
  }
}
