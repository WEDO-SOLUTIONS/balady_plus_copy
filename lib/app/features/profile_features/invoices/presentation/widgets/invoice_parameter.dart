import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';

class InvoiceParameter extends StatelessWidget {
  final String title;
  final String value;

  const InvoiceParameter({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          title,
          textStyle: AppStyle.requestParamterTitleTextStle,
        ),
        const SizedBox(height: 4),
        CustomTextWidget(
          value,
          textStyle: AppStyle.subMessageTextStle,
        ),
      ],
    );
  }
}
