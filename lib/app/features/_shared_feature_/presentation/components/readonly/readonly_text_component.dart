import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../shared_feature_exports.dart' show CustomHorizontalSpace, CustomTextWidget, WidgetLabel;

class ReadOnlyTextComponent extends StatelessWidget {
  final String label;
  final String value;
  final Widget? prefix;
  final Widget? suffix;
  const ReadOnlyTextComponent({super.key, required this.label, required this.value, this.prefix, this.suffix});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        WidgetLabel(label: label),
        //
        AnimatedContainer(
          duration: UIHelper.duration,
          padding: padding,
          decoration: const BoxDecoration(color: AppColor.gray, borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: LayoutBuilder(
            builder: (_, constraints) {
              final width = constraints.maxWidth;
              return Row(
                children: [
                  ///
                  if (prefix != null) SizedBox(width: 18.0, height: 18.0, child: prefix),
                  CustomHorizontalSpace(width: prefix != null ? 16.0 : 0.0),

                  ///
                  SizedBox(
                    width: width - subtractedWidth,
                    child: CustomTextWidget(
                      value,
                      textStyle: AppStyle.mainTextThirdStyle.copyWith(fontSize: 13.0, color: AppColor.black),
                    ),
                  ),

                  ///
                  CustomHorizontalSpace(width: suffix != null ? 16.0 : 0.0),
                  if (suffix != null) SizedBox(width: 18.0, height: 18.0, child: suffix),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  EdgeInsetsGeometry get padding => const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0);

  double get subtractedWidth => prefix != null && suffix != null
      ? (18.0 * 2) + (16.0 * 2)
      : prefix == null && suffix == null
      ? 0.0
      : 18.0 + 16.0;
}
