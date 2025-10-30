import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';

import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class EkramStatusWidget extends StatelessWidget {
  final String status;

  const EkramStatusWidget({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: new BoxDecoration(
            color: AppColor.orange150, borderRadius: BorderRadius.circular(4)),
        child: CustomTextWidget(
          status,
          fontColor: AppColor.orange800,
          fontWeight: AppFontWeight.medium,
          fontSize: 13,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class EkramHeaderAndDescWidget extends StatelessWidget {
  final String title;
  final String details;

  const EkramHeaderAndDescWidget(
      {Key? key, required this.title, required this.details})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          title,
          fontSize: 12.0,
          fontWeight: AppFontWeight.medium,
          fontColor: AppColor.primary700Light,
          maxLines: 4,
          textOverflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
        const CustomVerticalSpace(height: 6),
        CustomTextWidget(
          details,
          fontSize: 14.0,
          fontWeight: AppFontWeight.medium,
          fontColor: AppColor.blackModern600Light,
          maxLines: 4,
          textOverflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
