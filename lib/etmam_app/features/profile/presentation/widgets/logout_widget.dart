import 'package:balady_plus/etmam_app/core/utils/constants/app_color.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/icon_path.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomSvgIconWidget, CustomElevatedButtonWidget;
import 'package:flutter/material.dart';

class LogoutWidget extends StatelessWidget {
  final Function onPress;
  const LogoutWidget({Key? key, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButtonWidget(
      btnPressed: () => onPress(),
      btnText: trans("logout"),
      spaceBetweenTextAndIcon: 12,
      btnAlignment: Alignment.centerRight,
      btnPadding: EdgeInsets.symmetric(horizontal: 16),
      btnColor: AppColor.white,
      btnTextColor: AppColor.cherry,
      btnRadius: 12,
      icon: const CustomSvgIconWidget(
        IconPath.logoutIcon,
        iconSize: 24,
        iconColor: AppColor.cherry,
      ),
    );
  }
}
