import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../app/core/utils/constants/app_colors.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../../core/utils/constants/app_config.dart';

class HeaderWithAllButtonWidget extends StatelessWidget {
  final String header;
  final bool showAllButton;
  final VoidCallback? allOnPressed;
  final double? fontSize;

  const HeaderWithAllButtonWidget(
      {Key? key,
      required this.header,
      this.showAllButton = false,
      this.fontSize = 18,
      this.allOnPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // reports
          Flexible(
            child: CustomTextWidget(
              header,
              fontSize: fontSize,
              fontColor: AppColor.black,
              textAlign: TextAlign.start,
              height: 1.2,
              fontWeight: AppFontWeight.bold,
            ),
          ),
          // show all button
          Visibility(
            visible: showAllButton,
            child: GestureDetector(
              onTap: allOnPressed,
              child: CustomTextWidget(
                trans("show_all"),
                fontWeight: AppFontWeight.bold,
                fontColor: AppColor.primary900Light,
                fontSize: 13,
              ),
            ),
            // CustomTextButtonWithIconWidget(
            //   btnAlignment: AlignmentDirectional.centerEnd,
            //   btnPressed: allOnPressed!,
            //   icon: const Icon(
            //     Icons.arrow_back_ios_new,
            //     color: AppColor.black,
            //     size: 16.0,
            //   ),
            //   btnText: "customerVoiceShowAllButtonWord".tr(),
            //   btnTextColor: AppColor.black500,
            //   btnTextSize: 13.0,
            //   btnTextWeight: AppFontWeight.medium,
            // ),
          ),
        ],
      ),
    );
  }
}
