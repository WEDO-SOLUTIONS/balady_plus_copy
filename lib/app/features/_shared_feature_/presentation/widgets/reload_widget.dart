import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import 'buttons/custom_buttons_widgets.dart';
import 'custom_spaces_widgets.dart';

class ReloadWidget extends StatelessWidget {
  final double widgetHeight;
  final String? errorMessage;
  final VoidCallback onTab;

  const ReloadWidget({
    Key? key,
    this.widgetHeight = 150,
    this.errorMessage,
    required this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widgetHeight,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor.white,
        boxShadow: const [BoxShadow(color: Color(0x14d1d5db), offset: Offset(-2, 4), blurRadius: 8, spreadRadius: 0)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextWidget(
              errorMessage ?? ('data_not_retrieved').tr(),
              fontSize: 14,
              fontColor: AppColor.primary900Light,
              fontWeight: AppFontWeight.regular,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
          const CustomVerticalSpace(height: 16),
          CustomTextButtonWidget(
            onPressed: onTab,
            text: ('reload').tr(),
          )
        ],
      ),
    );
  }
}
