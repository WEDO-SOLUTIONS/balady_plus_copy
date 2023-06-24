import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class BookAppointmentDetailsHeaderSectionCardWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String subTitle;
  const BookAppointmentDetailsHeaderSectionCardWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSvgIconWidget(icon, iconHeight: 25.0, iconWidth: 25.0),
        Constants.horizontalSpaceSmall,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                title,
                fontColor: AppColor.black,
                fontSize: 17.0,
                textAlign: TextAlign.start,
              ),
              Constants.verticalSpaceSmall,
              CustomTextWidget(
                subTitle,
                fontSize: 13.0,
                fontColor: AppColor.black400,
                fontWeight: AppFontWeight.medium,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
