import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../shared_feature_exports.dart' show CustomTextWidget;

class DefaultAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final bool x;

  const DefaultAppBarWidget({
    super.key,
    this.title,
    this.bottom,
    this.actions,
    this.x = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.scaffoldBackground,
      elevation: 0,
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: Icon(
                x ? Icons.close : Icons.arrow_back_ios,
                color: AppColor.blackModern900Light,
                size: x ? 28 : null,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      centerTitle: false,
      title: CustomTextWidget(
        title ?? "",
        textAlign: TextAlign.center,
        textStyle: AppStyle.appBarTitleTextStyle,
      ),
      bottom: bottom,
      actions: actions,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
