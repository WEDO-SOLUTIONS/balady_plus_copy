import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NoAccountsWidget extends StatelessWidget {
  const NoAccountsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomVerticalSpace(height: 50),
        CustomSvgIconWidget(
          IconPath.noAvailableAccounts,
          iconSize: 48,
        ),
        CustomVerticalSpace(height: 18),
        CustomTextWidget(
          "no_valid_account".tr(),
          fontColor: Color(0xff52525B),
          fontSize: 14,
          fontWeight: AppFontWeight.bold,
        ),
      ],
    );
  }
}
