import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;

import '../../../../core/services/services_exports.dart' show NavigationService;
import '../../../../core/utils/utils_exports.dart' show AppColor, AppStyle, ContextConversion, WidgetConversion;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show ClickableWidget, CustomAutoSizeTextWidget, DrawIconBasedTypeWidget;

class BottomNavBarCardWidget extends StatelessWidget {
  final Object icon;
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const BottomNavBarCardWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final labelText = label.tr();
    return Semantics(
      selected: isSelected,
      label: labelText,
      child: ClickableWidget(
        onPressed: onSelected,
        effectColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ExcludeSemantics(
              child: DrawIconBasedTypeWidget(
                icon: icon,
                iconSize: iconSize,
                iconColor: isSelected ? AppColor.white : AppColor.primary200Light.withValues(alpha: 0.64),
              ),
            ),
            ExcludeSemantics(
              child: CustomAutoSizeTextWidget(
                labelText,
                textAlign: TextAlign.center,
                maxFontSize: labelSize,
                textStyle: AppStyle.mainTextStyle.copyWith(
                  color: isSelected ? AppColor.white : AppColor.primary200Light.withValues(alpha: 0.64),
                ),
              ),
            ),
          ].addPadding(bottom: 10.0),
        ),
      ),
    );
  }

  BuildContext get context => NavigationService.navigatorKey.currentContext!;
  double get width => context.screenWidth;
  double get iconSize => width > 600.0 ? 30.0 : 24.0;
  double get labelSize => width > 600.0 ? 13.0 : 12.0;
}
