import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/utils_exports.dart' show IconPath, AppColor;
import '../../../home_page/home_exports.dart' show CircleIcon;

class ProfileCard extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final bool isListItem;

  const ProfileCard({
    super.key,
    this.selected = false,
    required this.onTap,
    this.isListItem = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (isListItem) {
          onTap();
        } else {
          await BottomSheetDialog.showDraggableSheet(
            context,
            child: BottomSheetWithActions(
              title: "choose_profile".tr(),
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProfileCard(
                    onTap: () {},
                    selected: false,
                    isListItem: true,
                  ),
                  ProfileCard(
                    onTap: () {},
                    selected: true,
                    isListItem: true,
                  ),
                  ProfileCard(
                    onTap: () {},
                    selected: false,
                    isListItem: true,
                  ),
                ],
              ),
            ),
          );
        }
      },
      child: Container(
        margin: isListItem
            ? const EdgeInsets.symmetric(vertical: 8)
            : const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        height: 80,
        decoration: BoxDecoration(
          color: selected
              ? AppColor.primary900Light
              : AppColor.blackModern100Light,
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleIcon(
              icon: IconPath.profileIcon,
              iconColor: AppColor.primary700Light,
              // backgroundColor: AppColor.primary50Light,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  "محمد بن خالد",
                  textStyle: AppStyle.profileNameTextStyle.copyWith(
                      color: selected
                          ? AppColor.blackModern50Light
                          : AppColor.blackModern600Light),
                ),
                const SizedBox(height: 8),
                CustomTextWidget(
                  "حساب فرد",
                  textStyle: AppStyle.profileTypeTextStyle.copyWith(
                    color: selected
                        ? AppColor.blackModern50Light.withOpacity(0.6)
                        : AppColor.blackModern600Light.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (!isListItem)
              SvgPicture.asset(
                IconPath.arrowDown,
              )
          ],
        ),
      ),
    );
  }
}
