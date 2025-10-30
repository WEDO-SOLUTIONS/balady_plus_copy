import 'package:balady_plus/etmam_app/core/utils/enums/app_font_weight.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_color.dart';

class ProfileHeaderItem extends StatelessWidget {
  final String title;
  final bool showTopPadding;
  const ProfileHeaderItem(
      {Key? key, required this.title, this.showTopPadding = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: showTopPadding ? const EdgeInsets.only(top: 24) : null,
      child: CustomTextWidget(
        title,
        fontColor: AppColor.bottomNavigationShadow,
        fontSize: 14,
        fontWeight: AppFontWeight.medium,
      ),
    );
  }
}
