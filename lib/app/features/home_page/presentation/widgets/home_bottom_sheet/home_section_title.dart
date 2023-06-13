import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget;
import '../home_tag.dart';

class HomeSectionTitle extends StatelessWidget {
  final String title;
  final bool isNew;

  const HomeSectionTitle({
    super.key,
    required this.title,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTextWidget(
          title,
          textStyle: AppStyle.sectionTitleStyle,
        ),
        if (isNew)
          HomeTag(
            title: 'new'.tr(),
            color: AppColor.blue900Light,
            selected: true,
            fontSize: 11.0,
          ),
      ],
    );
  }
}
