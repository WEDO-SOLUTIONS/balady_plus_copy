import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';

class CardDescWidget extends StatelessWidget {
  final Object icon;
  final String title, description;
  final Widget? widget;

  const CardDescWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: AppColor.darkSlateBlue6,
            offset: Offset(0, -4),
            blurRadius: 32,
          )
        ],
        color: AppColor.blackModern50Light,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              DrawIconBasedTypeWidget(icon: icon),
              const SizedBox(width: 4),
              Flexible(
                fit: FlexFit.tight,
                child: CustomTextWidget(
                  title,
                  textStyle: AppStyle.serviceListTitleTextStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextWidget(
            description,
            textStyle: AppStyle.serviceCardDescriptionTextStyle,
            maxLines: 6,
          ),
          widget ?? const SizedBox(),
        ],
      ),
    );
  }
}
