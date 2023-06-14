import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../shared_feature_exports.dart' show CustomTextWidget;

class DefaultAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;

  const DefaultAppBarWidget({
    super.key,
    this.title,
    this.bottom,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.scaffoldBackground,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextWidget(
            title ?? "",
            textAlign: TextAlign.center,
            textStyle: AppStyle.appBarTitleTextStyle,
          ),
        ],
      ),
      bottom: bottom,
      actions: actions,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
