import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/utils_exports.dart' show IconPath, AppColor;
import '../../../home_page/home_exports.dart' show CircleIcon;

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      height: 80,
      decoration: const BoxDecoration(
        color: AppColor.primary900Light,
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleIcon(
            icon: IconPath.profileIcon,
            iconColor: AppColor.primary700Light,
            backgroundColor: AppColor.primary50Light,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                "محمد بن خالد",
                textStyle: AppStyle.profileNameTextStyle,
              ),
              const SizedBox(height: 8),
              CustomTextWidget(
                "حساب فرد",
                textStyle: AppStyle.profileTypeTextStyle,
              ),
            ],
          ),
          const Spacer(),
          SvgPicture.asset(
            IconPath.arrowDown,
          )
        ],
      ),
    );
  }
}
