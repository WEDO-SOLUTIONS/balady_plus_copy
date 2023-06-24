import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../widgets/buttons/custom_buttons_widgets.dart';
import '../widgets/draw_line_widget.dart';
import '../widgets/texts/custom_text_widget.dart';

class DialogHeader extends StatelessWidget {
  final String title;
  final withDivider;

  const DialogHeader({Key? key, required this.title, this.withDivider = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
          child: Row(
            children: [
              CustomTextButtonWidget(
                text: ('customerVoiceCloseButtonWord').tr(),
                onPressed: Navigator.of(context).pop,
                btnTextColor: AppColor.grey1000,
                btnTextSize: 17,
                btnTextWeight: AppFontWeight.medium,
                btnSize: Size(20, 20),
              ),
              Expanded(
                child: CustomTextWidget(
                  title,
                  fontColor: AppColor.black,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 17,
                  maxLines: 2,
                ),
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
        ),
        const CustomVerticalSpace(height: 24),
        withDivider
            ? const DrawLineWidget()
            : const CustomVerticalSpace(height: 12)
      ],
    );
  }
}
