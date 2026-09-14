import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../../shared_feature_exports.dart'
    show ClickableWidget, CustomHorizontalSpace, CustomTextWidget, DrawIconBasedTypeWidget;

class DropDownComponent extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final bool isSelected;
  final String dropDownText;
  final Object? dropDownIcon;
  final VoidCallback onPressed;

  const DropDownComponent({
    super.key,
    this.margin,
    this.isSelected = false,
    required this.dropDownText,
    this.dropDownIcon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onPressed: onPressed,
      child: Container(
        margin: margin ?? const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: borderColor),
          color: color,
        ),
        child: Row(
          children: [
            //
            if (dropDownIcon != null) ...[
              DrawIconBasedTypeWidget(icon: dropDownIcon ?? ""),
              const CustomHorizontalSpace(width: 10.0),
            ],
            //
            Expanded(
              child: CustomTextWidget(
                dropDownText,
                textAlign: TextAlign.start,
                textStyle: AppStyle.mainTextThirdStyle.copyWith(color: AppColor.gray, fontSize: 14.0, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get borderColor => isSelected ? AppColor.gray.withValues(alpha: 0.5) : AppColor.gray.withValues(alpha: 0.2);
  Color get color => isSelected ? AppColor.gray.withValues(alpha: 0.1) : AppColor.white;
}
