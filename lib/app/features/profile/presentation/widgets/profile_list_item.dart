import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, ContextConversion;
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
        if (item.route.isEmpty) return;
        context.pushNamedRoute(item.route, arguments: item.args);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            DrawIconBasedTypeWidget(
              icon: item.icon,
              iconColor: AppColor.primary600Light,
            ),
            const SizedBox(width: 16),
            CustomTextWidget(
              item.title,
              textStyle: AppStyle.listTitleTextStyle,
            ),
            const Spacer(),
            if (item.beta)
              CustomTextWidget(
                "beta".tr(),
                textStyle: AppStyle.profileListBetaTextStyle,
              ),
            const SizedBox(width: 16),
            SvgPicture.asset(IconPath.leftArrow),
          ],
        ),
      ),
    );
  }
}
