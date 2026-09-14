import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../widgets/draw_line_widget.dart';
import '../widgets/texts/custom_text_widget.dart';

class DialogHeader extends StatelessWidget {
  final String title;
  final withDivider;

  const DialogHeader({super.key, required this.title, this.withDivider = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: CustomTextWidget(
                  title,
                  textAlign: TextAlign.start,
                  maxLines: 3,
                  textStyle: AppStyle.mainTextSecondaryStyle.copyWith(
                    fontSize: 20.0,
                    color: AppColor.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: CircleIcon(
                  icon: Icons.close,
                  iconColor: AppColor.primary600Light,
                  backgroundColor: AppColor.geyser.withValues(alpha: 0.4),
                  iconSize: 18,
                ),
              ),
            ],
          ),
        ),
        withDivider ? const DrawLineWidget() : const CustomVerticalSpace(height: 12),
      ],
    );
  }
}
