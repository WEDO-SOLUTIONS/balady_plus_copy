import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget;

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomTextWidget(
          "more".tr(),
          textStyle:
              AppStyle.mainTextSecondaryStyle.copyWith(color: AppColor.white),
        ),
      ),
      body: Center(
        child: CustomTextWidget("more".tr()),
      ),
    );
  }
}
