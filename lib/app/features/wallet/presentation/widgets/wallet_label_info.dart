import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class WalletLabelInfo extends StatelessWidget {
  final String? title;
  final String? subTitle;
  const WalletLabelInfo({super.key, this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomTextWidget(
            title ?? "",
            fontSize: 11,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.blackModern50Light.withOpacity(0.5),
          ),
          const SizedBox(height: 4),
          CustomTextWidget(
            subTitle ?? "",
            fontSize: 13,
            maxLines: 10,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.blackModern50Light,
          ),
        ],
      ),
    );
  }
}
