import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget;

class ServiceCardParameter extends StatelessWidget {
  final String title;
  final String iconName;
  final String value;

  const ServiceCardParameter({
    super.key,
    required this.title,
    required this.iconName,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 118,
      height: 73,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: AppColor.blackModern100Light,
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
              CustomTextWidget(
                value,
                textStyle: AppStyle.serviceCardParameterTitleTextStyle,
              ),
            ],
          )
        ],
      ),
    );
  }
}
