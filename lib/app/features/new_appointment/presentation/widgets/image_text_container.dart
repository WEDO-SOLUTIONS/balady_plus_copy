import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageTextContainer extends StatelessWidget {
  final String name;
  final String icon;
  const ImageTextContainer({super.key, required this.icon, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 144,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.blackModern100Light,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            SvgPicture.asset(
              icon,
              width: 46,
              height: 46,
            ),
            CustomVerticalSpace(height: 16),
            CustomTextWidget(
              name,
              fontColor: AppColor.blackModern600Light,
              fontSize: 14,
              maxLines: 2,
              height: 1.3,
              fontWeight: AppFontWeight.bold,
            )
          ],
        ));
  }
}
