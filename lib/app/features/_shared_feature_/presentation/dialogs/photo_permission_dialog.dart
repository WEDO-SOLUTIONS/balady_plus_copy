import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../widgets/buttons/custom_buttons_widgets.dart';
import '../widgets/texts/custom_text_widget.dart';

class PhotoPermissionDialog extends StatelessWidget {
  const PhotoPermissionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(12)),
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
                        child: Image.asset(
                          IconPath.qrWhiteCloseIcon,
                          height: 16.0,
                          width: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Constants.verticalSpaceMedium,
                  CustomTextWidget(
                    ("noPhotoPermission").tr(),
                    fontColor: AppColor.black,
                    fontWeight: AppFontWeight.medium,
                    fontSize: 22,
                  ),
                  Constants.verticalSpaceMedium,
                  CustomTextWidget(
                    ("noPhotoPermissionDesc").tr(),
                    fontColor: AppColor.grey1000,
                    fontWeight: AppFontWeight.medium,
                    fontSize: 16,
                  ),
                  Constants.verticalSpaceMedium,
                  EnhancedCustomElevatedButtonWidget(
                    btnPressed: () {
                      Navigator.of(context).pop();
                      openAppSettings();
                    },
                    btnText: ("settings").tr(),
                    btnTextSize: 16,
                    btnTextWeight: AppFontWeight.regular,
                    btnHeight: 56,
                    btnWidth: 240,
                  ),
                  Constants.verticalSpaceSmall,
                  CustomTextButtonWidget(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: ("notNow").tr(),
                    btnTextSize: 16,
                    btnTextWeight: AppFontWeight.regular,
                  )
                ],
              )),
        ],
      ),
    );
  }
}
