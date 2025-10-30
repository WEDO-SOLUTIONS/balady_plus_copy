import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_style.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class StatusTag extends StatelessWidget {
  String name;
  Function? onTap;
  StatusTag({super.key, this.onTap, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap != null ? onTap!() : null,
      child: Row(
        children: [
          Container(
            height: 24,
            decoration: BoxDecoration(
              color: AppColor.secondary100Light,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  CustomTextWidget(
                    name,
                    textStyle: AppStyle.tagTextStyle,
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppColor.primary900Light,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
