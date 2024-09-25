import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

class WidgetTitleInvoice extends StatelessWidget {
  final String money, title;

  const WidgetTitleInvoice({
    super.key,
    required this.money,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomTextWidget(
          money,
          textStyle: AppStyle.serviceCardWarningTitleTextStyle,
        ),
        const Spacer(),
        CustomTextWidget(
          title,
          textStyle: AppStyle.serviceCardDescriptionTextStyle,
        ),
      ],
    );
  }
}
