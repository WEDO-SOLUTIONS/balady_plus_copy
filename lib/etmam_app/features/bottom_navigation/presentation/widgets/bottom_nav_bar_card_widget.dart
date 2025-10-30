import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import '../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomAutoSizeTextWidget, CustomVerticalSpace, DrawIconBasedTypeWidget;
import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppColorsTheme, AppStyle, ContextConversion;

class BottomNavBarCardWidget extends StatelessWidget {
  final Object icon;
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const BottomNavBarCardWidget({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon widget
          DrawIconBasedTypeWidget(
            icon: icon,
            iconSize: iconSize,
            iconColor:
                isSelected ? AppColorsTheme.primary700 : AppColor.hunterGreen,
          ),
          // Space
          const CustomVerticalSpace(height: 10.0),
          // Label widget
          CustomAutoSizeTextWidget(
            label.tr(),
            textAlign: TextAlign.center,
            maxFontSize: labelSize,
            textStyle: AppStyle.mainTextStyle.copyWith(
              // fontSize: 10.0,
              color:
                  isSelected ? AppColorsTheme.primary700 : AppColor.hunterGreen,
            ),
          ),
        ],
      ),
    );
  }

  BuildContext get context => NavigationService.navigatorKey.currentContext!;
  double get width => context.screenWidth;
  double get iconSize => width > 600.0 ? 30.0 : 24.0;
  double get labelSize => width > 600.0 ? 13.0 : 12.0;
}
