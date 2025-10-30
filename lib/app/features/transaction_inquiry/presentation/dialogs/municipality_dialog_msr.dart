import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class MunicipalityMSRDialog extends StatelessWidget {
  const MunicipalityMSRDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg = Helpers.translatingWord("service_not_available");
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: AppColor.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.close),
                    ),
                  ],
                ),
                const CustomSvgIconWidget(
                  IconPath.location,
                  iconSize: 82,
                ),
                Constants.verticalSpaceLarge,
                CustomTextWidget(
                  Helpers.translatingWord("region_coverage_error"),
                  fontColor: AppColor.blackModern600Light,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 20,
                ),
                Constants.verticalSpaceMedium,
                CustomTextWidget(
                  msg,
                  fontColor: AppColor.blackModern500Light,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 18,
                  height: 1.5,
                  textAlign: TextAlign.center,
                  maxLines: null,
                ),
                Constants.verticalSpaceLarge,
                EnhancedCustomElevatedButtonWidget(
                  btnPressed: () {
                    Helpers.backNavigationToHomeScreen();
                  },
                  btnText: Helpers.translatingWord("go_to_main_screen"),
                  btnTextSize: 18,
                  btnTextWeight: AppFontWeight.bold,
                  btnTextColor: AppColor.white,
                  btnHeight: 56,
                  btnRadius: 8,
                ),
                Constants.verticalSpaceSmall,
              ],
            )),
      ],
    );
  }
}
