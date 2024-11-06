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

class EkramHeaderAndDescWidget_new extends StatelessWidget {
  final String title;
  final String details;

  const EkramHeaderAndDescWidget_new(
      {Key? key, required this.title, required this.details})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          title,
          fontSize: 15.0,
          fontWeight: AppFontWeight.bold,
          fontColor: AppColor.blackModern700Light,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
        const CustomVerticalSpace(height: 10),
        
        Container(
          width: MediaQuery.of(context).size.width ,
          decoration: new BoxDecoration(
              color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),
          // padding: EdgeInsets.all(24),
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(bottom: 15),
          child: CustomTextWidget(
            details,
            fontSize: 14.0,
            fontWeight: AppFontWeight.medium,
            fontColor: AppColor.grey1000.withOpacity(0.5),
            maxLines: 4,
            textOverflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}


class EkramHeaderAndDescWidget_With_Background extends StatelessWidget {
  final String title;
  final String details;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  const EkramHeaderAndDescWidget_With_Background(
      {Key? key, required this.title, required this.details,this.color,this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
      width: MediaQuery.of(context).size.width ,
      decoration: new BoxDecoration(
          color: color?? AppColor.greenOptacty.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
      // padding: EdgeInsets.all(24),
      padding: EdgeInsets.all(12),
      margin: margin??EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            title,
            fontSize: 11.0,
            fontWeight: AppFontWeight.bold,
            fontColor:AppColor.primary800Light2 ,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
          const CustomVerticalSpace(height: 10),

          CustomTextWidget(
            details,
            fontSize: 12.0,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.blackModern700Light,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}