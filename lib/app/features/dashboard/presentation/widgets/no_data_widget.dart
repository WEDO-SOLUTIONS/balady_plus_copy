import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomSvgIconWidget(
            IconPath.note2,
            iconSize: 52,
            iconColor: Theme.of(context).primaryColor,
            
          ),
          const SizedBox(height: 6),
          CustomTextWidget(
            "noData".tr(),
            fontSize: 18,
            fontWeight: AppFontWeight.bold,
            fontColor: Theme.of(context).colorScheme.onPrimary,
            
          ),
        ],
      ),
    );
  }
}
