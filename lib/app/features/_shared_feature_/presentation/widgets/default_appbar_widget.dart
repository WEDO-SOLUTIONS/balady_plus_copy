import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, AppStyle, ImagePath;
import '../../shared_feature_exports.dart' show CustomTextWidget;

class DefaultAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final bool x;
  final Widget? flexibleSpace;
  final VoidCallback? onBack;
  final bool showBack;
  Widget? titleWidget;

  DefaultAppBarWidget(
      {super.key,
      this.title,
      this.bottom,
      this.actions,
      this.showBack = true,
      this.x = false,
      this.onBack,
      this.flexibleSpace,
      this.titleWidget});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: flexibleSpace == null ? Colors.transparent : AppColor.scaffoldBackground,
      elevation: 0,
      shadowColor: AppColor.primary100Light,
      leadingWidth: showBack == true ? null : 8,
      leading: Navigator.canPop(context) && showBack
          ? IconButton(
              icon: Icon(
                x ? Icons.close : Icons.arrow_back_ios,
                color: AppColor.blackModern900Light,
                size: x ? 28 : null,
              ),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
            )
          : null,
      titleSpacing: Navigator.canPop(context) ? 0 : 16,
      centerTitle: false,
      title: titleWidget ??
          CustomTextWidget(
            title ?? "",
            fontSize: 20,
            maxLines: 3,
            textOverflow: TextOverflow.ellipsis,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.blackModern700Light,
          ),
      bottom: bottom,
      actions: actions,
      flexibleSpace: flexibleSpace ??
          Image.asset(
            ImagePath.appbarBg,
            fit: BoxFit.fill,
          ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
