import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget;

class ServiceCardParameter extends StatelessWidget {
  final String title;
  final String iconName;
  final String value;
  final double width;

  const ServiceCardParameter({
    super.key,
    required this.title,
    required this.iconName,
    required this.value,
    this.width = 118,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 77,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color(0x80E6EFEF),
      ),
      child: Column(
        children: [
          CustomTextWidget(
            title,
            textStyle: AppStyle.serviceCardParameterTitleTextStyle,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DrawIconBasedTypeWidget(
                icon: iconName,
                iconSize: 16,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: CustomTextWidget(
                  value,
                  maxLines: 1,
                  textStyle: AppStyle.serviceCardParameterTitleTextStyle
                      .copyWith(color: AppColor.blackModern500Light),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
