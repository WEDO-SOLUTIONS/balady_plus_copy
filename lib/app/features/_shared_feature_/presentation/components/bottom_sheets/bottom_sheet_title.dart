import 'package:flutter/material.dart';

import '../../../../../core/services/services_exports.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../home_page/home_exports.dart';
import '../../../shared_feature_exports.dart';

class BottomSheetTitle extends StatelessWidget {
  final String title;
  final Widget body;
  const BottomSheetTitle({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      color: AppColor.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const DrawLineWidget(
            lineWidth: 70.0,
            lineHeight: 6.0,
            lineColor: AppColor.gray,
            radius: 46.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                title,
                textAlign: TextAlign.center,
                textStyle: AppStyle.mainTextSecondaryStyle.copyWith(
                  fontSize: 24.0,
                  color: AppColor.black,
                ),
              ),
              InkWell(
                onTap: context.popDialog,
                child: CircleIcon(
                  icon: Icons.close,
                  iconColor: AppColor.primary600Light,
                  backgroundColor: AppColor.geyser.withOpacity(0.4),
                  iconSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          body,
        ],
      ),
    );
  }

  EdgeInsetsGeometry get padding => EdgeInsets.only(
        right: UIHelper.mediumPadding,
        left: UIHelper.mediumPadding,
        top: UIHelper.smallPadding,
        bottom: context.bottomPadding,
      );
  BuildContext get context => NavigationService.navigatorKey.currentContext!;
}
