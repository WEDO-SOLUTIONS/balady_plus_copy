import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../../home_page/home_exports.dart' show CircleIcon;
import '../../profile_exports.dart' show ProfileItem;

class ProfileListItem extends StatelessWidget {
  final ProfileItem item;
  const ProfileListItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Add route here
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleIcon(
              icon: item.icon,
              iconColor: AppColor.primary600Light,
              backgroundColor: AppColor.primary50Light,
            ),
            const SizedBox(width: 16),
            CustomTextWidget(
              item.title,
              textStyle: AppStyle.profileListTitleTextStyle,
            ),
            const Spacer(),
            SvgPicture.asset(IconPath.leftArrow),
          ],
        ),
      ),
    );
  }
}
