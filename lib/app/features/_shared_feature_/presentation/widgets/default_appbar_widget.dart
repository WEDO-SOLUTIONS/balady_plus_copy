import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, ContextConversion;
import '../../shared_feature_exports.dart'
    show CustomTextWidget, IconButtonWidget;

class DefaultAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  /// It can be String or Widget
  final dynamic title;
  final bool hideCloseButton;
  final VoidCallback? onClose;
  final Widget? leading;
  const DefaultAppBarWidget({
    super.key,
    this.hideCloseButton = false,
    this.title,
    this.onClose,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.white,
      elevation: 1.0,
      automaticallyImplyLeading: false,
      leadingWidth: 0.0,
      titleSpacing: 0.0,
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //
            CustomTextWidget(
              title ?? "",
              textAlign: TextAlign.center,
              textStyle: AppStyle.appBarTitleTextStyle,
            ),
            //
            const SizedBox(width: 40.0, height: 40.0),
            //
            if (leading != null) leading!,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
