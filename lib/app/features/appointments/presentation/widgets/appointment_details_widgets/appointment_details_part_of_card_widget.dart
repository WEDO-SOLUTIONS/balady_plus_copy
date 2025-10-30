import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class AppointmentDetailsPartOfCardWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  const AppointmentDetailsPartOfCardWidget({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          title,
          fontColor: AppColor.baladyDarkGreen2,
          fontSize: 13.0,
        ),
        const CustomVerticalSpace(height: 8.0),
        CustomTextWidget(
          subTitle,
          fontColor: AppColor.black,
          textAlign: TextAlign.start,
          fontWeight: AppFontWeight.medium,
          height: 1.3,
        ),
      ],
    );
  }
}
