import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

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

  DefaultAppBarWidget({
    super.key,
    this.title,
    this.bottom,
    this.actions,
    this.showBack = true,
    this.x = false,
    this.onBack,
    this.flexibleSpace,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      //  shadowColor: Theme.of(context).shadowColor,
      leadingWidth: showBack == true ? null : 8,
      leading: Navigator.canPop(context) && showBack
          ? IconButton(
              tooltip: 'a11yBack'.tr(),
              icon: Icon(
                x ? Icons.close : Icons.arrow_back_ios,
                color: Theme.of(context).colorScheme.onSurface,
                size: x ? 28 : null,
              ),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
            )
          : null,
      titleSpacing: Navigator.canPop(context) ? 0 : 16,
      centerTitle: false,
      title:
          titleWidget ??
          CustomTextWidget(
            title ?? "",
            fontSize: 20,
            maxLines: 3,
            textOverflow: TextOverflow.ellipsis,
            fontWeight: AppFontWeight.bold,
            fontColor: Theme.of(context).colorScheme.onSurface,
          ),
      bottom: bottom,
      actions: actions,
      flexibleSpace: flexibleSpace ?? SizedBox(),
      // Image.asset(
      //   ImagePath.appbarBg,
      //   fit: BoxFit.fill,
      // ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
