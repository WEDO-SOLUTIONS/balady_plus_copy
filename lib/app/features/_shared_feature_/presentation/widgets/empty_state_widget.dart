import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

import 'custom_spaces_widgets.dart';

class EmptyStateWidget extends StatelessWidget {
  final String? img;
  final String? title;
  final String? desc;

  const EmptyStateWidget({Key? key, this.desc, this.img, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              img ?? "assets/images/searchEmptyIcon.png",
              width: 105,
              height: 69,
            ),
            const CustomVerticalSpace(height: 18),
            CustomTextWidget(
              title ?? "",
              fontSize: 17.0,
              fontColor: AppColor.black800,
              fontWeight: AppFontWeight.bold,
            ),
            const CustomVerticalSpace(height: 18),
            CustomTextWidget(
              desc ?? "",
              fontSize: 13.0,
              height: 1.6,
              fontColor: AppColor.black400,
              fontWeight: AppFontWeight.medium,
            ),
          ],
        ),
      ),
    );
  }
}
