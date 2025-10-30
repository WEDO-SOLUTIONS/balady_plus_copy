import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show
        AppColor,
        AppColorsTheme,
        AppFontWeight,
        ButtonIconPosition,
        CommonFunctions,
        IconPath,
        trans;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomElevatedButtonWidget, CustomSvgIconWidget;
import 'package:flutter/material.dart';

class DownloadProjectFileButton extends StatelessWidget {
  final String documentUrl;

  const DownloadProjectFileButton({Key? key, required this.documentUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButtonWidget(
      btnText: trans("download_project_file"),
      btnTextSize: 16,
      btnTextColor: AppColor.darkTurquoise,
      btnTextWeight: AppFontWeight.medium,
      btnColor: AppColor.white,
      btnBorderColor: AppColor.darkTurquoise,
      btnHeight: 48,
      btnRadius: 2,
      btnBorderWidth: 2,
      buttonIconPosition: ButtonIconPosition.right,
      spaceBetweenTextAndIcon: 16,
      icon: CustomSvgIconWidget(
        IconPath.downloadProjectFileIcon,
        iconHeight: 17,
        iconWidth: 15,
        iconColor: AppColor.darkTurquoise,
      ),
      btnPressed: () {
        CommonFunctions.externalLaunch(documentUrl);
      },
    );
  }
}
