import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class HeaderWithAll extends StatelessWidget {
  final String text;
  final Function onPressAll;
  final EdgeInsets? margin;
  final Color? showAllColor;
  final Color? titleColor;
  const HeaderWithAll(
      {super.key,
      required this.onPressAll,
      required this.text,
      this.margin,
      this.showAllColor,
      this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextWidget(
            text,
            fontSize: 16,
            fontWeight: AppFontWeight.bold,
            fontColor: titleColor ?? const Color(0xff1E2A36),
          ),
          InkWell(
            onTap: () => onPressAll(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextWidget(
                  "show_all".tr(),
                  fontSize: 14,
                  fontWeight: AppFontWeight.regular,
                  fontColor: showAllColor ?? const Color(0xff1E2A36),
                ),
                const SizedBox(
                  width: 4,
                ),
                DrawIconBasedTypeWidget(
                  icon: Icons.arrow_forward_ios,
                  iconSize: 16,
                  iconColor: showAllColor ?? const Color(0xff1E2A36),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
