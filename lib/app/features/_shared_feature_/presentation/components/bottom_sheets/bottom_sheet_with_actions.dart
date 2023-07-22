import 'package:flutter/material.dart';

import '../../../../../core/services/services_exports.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../home_page/home_exports.dart';
import '../../../shared_feature_exports.dart';

class BottomSheetWithActions extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? action;

  const BottomSheetWithActions({
    super.key,
    required this.title,
    required this.body,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: padding,
        height: context.screenHeight * 0.90,
        color: AppColor.white,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                          onTap: () => Navigator.pop(context),
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
              ),
            ),
            if (action != null) action!
          ],
        ),
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
