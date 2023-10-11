import 'package:flutter/cupertino.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../../shared_feature_exports.dart' show CustomTextWidget;

class CustomCupertinoPickerWidget extends StatelessWidget {
  /// It maybe list of widgets or list of strings
  final List<dynamic> children;
  final TextStyle? textStyle;
  final void Function(int) onSelectedItem;
  const CustomCupertinoPickerWidget({
    super.key,
    required this.children,
    this.textStyle,
    required this.onSelectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker.builder(
      itemExtent: 35.0,
      diameterRatio: 1.0,
      backgroundColor: AppColor.white,
      useMagnifier: true,
      magnification: 1.1,
      childCount: children.length,
      onSelectedItemChanged: onSelectedItem,
      itemBuilder: (_, index) => Align(
        alignment: Alignment.center,
        child: children is List<Widget>
            ? children[index]
            : children is List<String>
                ? CustomTextWidget(
                    children[index],
                    textStyle: textStyle ?? AppStyle.pickerStyle,
                  )
                : null,
      ),
    );
  }
}
