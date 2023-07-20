import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show UIHelper;
import '../../../shared_feature_exports.dart' show ReadOnlyFieldComponent;

class ReadOnlyFieldsSingleRowComponent extends StatelessWidget {
  final String firstFieldLabel;
  final String firstFieldValue;
  final String secondFieldLabel;
  final String secondFieldValue;
  const ReadOnlyFieldsSingleRowComponent({
    super.key,
    required this.firstFieldLabel,
    required this.firstFieldValue,
    required this.secondFieldLabel,
    required this.secondFieldValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Gender
        Expanded(
          child: ReadOnlyFieldComponent(
            label: firstFieldLabel,
            initialValue: firstFieldValue,
          ),
        ),
        //* Space
        UIHelper.horizontalSmallSpace,
        // IdentityNo
        Expanded(
          child: ReadOnlyFieldComponent(
            label: secondFieldLabel,
            initialValue: secondFieldValue,
          ),
        ),
      ],
    );
  }
}
