import 'package:balady_new_app/app/core/core_exports.dart';
import 'package:flutter/material.dart';

import '../../../../core/shared_widgets/custom_text_widget.dart';

class EkramStatusWidget extends StatelessWidget {
  final String status;

  const EkramStatusWidget({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: new BoxDecoration(
            color: AppColors.orange150, borderRadius: BorderRadius.circular(4)),
        child: CustomTextWidget(
          status,
          fontColor: AppColors.orange800,
          fontWeight: FONT_WEIGHT.medium,
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
          fontSize: 13.0,
          fontWeight: FONT_WEIGHT.medium,
          fontColor: AppColors.warmGrey,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
        const CustomVerticalSpace(height: 6),
        CustomTextWidget(
          details,
          fontSize: 16.0,
          fontWeight: FONT_WEIGHT.medium,
          fontColor: AppColors.black,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
