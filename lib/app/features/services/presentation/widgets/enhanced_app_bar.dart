import 'package:flutter/material.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor;
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class EnhancedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final bool x;
  final Widget? flexibleSpace;
  final VoidCallback? onBack;
  final bool showBack;
  final Color? titleColor;

  const EnhancedAppBar(
      {super.key,
      this.title,
      this.bottom,
      this.actions,
      this.showBack = true,
      this.x = false,
      this.onBack,
      this.titleColor,
      this.flexibleSpace});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: flexibleSpace == null
          ? Colors.transparent
          : AppColor.scaffoldBackground,
      elevation: 0,
      shadowColor: titleColor ?? AppColor.primary100Light,
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
      centerTitle: true,
      title: CustomTextWidget(
        title ?? "",
        fontSize: 20,
        maxLines: 1,
        textOverflow: TextOverflow.ellipsis,
        fontWeight: AppFontWeight.bold,
        fontColor: AppColor.blackModern700Light,
      ),
      bottom: bottom,
      actions: actions,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
