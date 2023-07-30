import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, UIHelper;

class WidgetLabel extends StatelessWidget {
  final String? label;
  final TextStyle? labelStyle;
  final bool isRequired;
  final EdgeInsetsGeometry? padding;
  const WidgetLabel({
    Key? key,
    this.label,
    this.labelStyle,
    this.isRequired = false,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return label != null && label!.isNotEmpty
        ? Padding(
            padding: labelPadding,
            child: AutoSizeText.rich(
              // TextSpan(
              //   text: label,
              //   children: [
              //     if (isRequired)
              //       const TextSpan(
              //         text: '*',
              //         style: TextStyle(color: AppColor.error),
              //       ),
              //   ],
              // ),
              TextSpan(
                text: isRequired ? "* " : "",
                children: [
                  TextSpan(
                    text: label,
                    style: labelStyle ??
                        AppStyle.mainTextSecondaryStyle
                            .copyWith(fontSize: 14.0),
                  ),
                ],
              ),
              style: const TextStyle(color: AppColor.error, fontSize: 20.0),
              minFontSize: 10.0,
            ),
          )
        : const SizedBox();
  }

  EdgeInsetsGeometry get labelPadding =>
      padding ?? const EdgeInsets.only(bottom: UIHelper.littlePadding);
}
