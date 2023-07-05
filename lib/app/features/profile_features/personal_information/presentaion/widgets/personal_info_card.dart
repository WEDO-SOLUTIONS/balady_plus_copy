import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget;

class PersonalInfoCard extends StatelessWidget {
  final String title;
  final String icon;
  final List<Widget> children;

  const PersonalInfoCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColor.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              DrawIconBasedTypeWidget(
                icon: icon,
                iconSize: 20,
              ),
              const SizedBox(width: 4),
              CustomTextWidget(
                title,
                textStyle: AppStyle.cardTitleTextStle,
              ),
            ],
          ),
          ...children,
        ],
      ),
    );
  }
}
