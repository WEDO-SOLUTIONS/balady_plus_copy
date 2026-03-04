import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;

import '../../../../core/utils/utils_exports.dart' show AppColor, AppStyle, UIHelper;

class WidgetLabel extends StatelessWidget {
  final String? label;
  final TextStyle? labelStyle;
  final bool isRequired;
  final EdgeInsetsGeometry? padding;
  const WidgetLabel({
    super.key,
    required this.label,
    this.labelStyle,
    this.isRequired = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return label != null
        ? Padding(
            padding: labelPadding,
            child: AutoSizeText.rich(
              TextSpan(
                text: isRequired ? "* " : "",
                children: [
                  TextSpan(
                    text: label!.isEmpty ? "notFound".tr() : label,
                    style: labelStyle ??
                        AppStyle.mainTextSecondaryStyle
                            .copyWith(fontSize: 16.0, fontWeight: FontWeight.bold, color: AppColor.blackModern700Light),
                  ),
                ],
              ),
              style: const TextStyle(color: AppColor.error, fontSize: 20.0),
              minFontSize: 10.0,
            ),
          )
        : const SizedBox();
  }

  EdgeInsetsGeometry get labelPadding => padding ?? const EdgeInsets.only(bottom: UIHelper.littlePadding);
}
