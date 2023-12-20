import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/utils/constants/constants.dart';

class SaveDraftDialog extends StatelessWidget {
  final Function onClose;
  final Function onSave;
  const SaveDraftDialog({Key? key, required this.onClose, required this.onSave})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                Image.asset(
                  ImagePath.exitLogo,
                  width: 82,
                  height: 82,
                ),
                CustomVerticalSpace(height: 16),
                CustomTextWidget(
                  "exit_order".tr(),
                  fontColor: AppColor.blackModern600Light,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 20,
                ),
                CustomVerticalSpace(height: 16),
                CustomTextWidget(
                  "cancellation_license_message".tr(),
                  fontColor: AppColor.blackModern500Light,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 18,
                  height: 1.5,
                  textAlign: TextAlign.center,
                  maxLines: null,
                ),
                CustomVerticalSpace(height: 16),
                ElevatedButtonWidget.primaryCustom(
                  onPressed: () {
                    Navigator.pop(context);

                    onSave();
                  },
                  text: Helpers.translatingWord("save_exit"),
                ),
                CustomVerticalSpace(height: 16),
                ElevatedButtonWidget.primaryCustomBorder(
                  onPressed: () {
                    Navigator.pop(context);
                    onClose();
                  },
                  text: Helpers.translatingWord("back_order"),
                ),
                /* EnhancedCustomElevatedButtonWidget(
                  btnPressed: () {},
                  btnText: Helpers.translatingWord("حفظ وخروج"),
                  btnTextSize: 18,
                  btnTextWeight: AppFontWeight.bold,
                  btnTextColor: AppColor.white,
                  btnHeight: 56,
                  btnRadius: 8,
                ),*/
                Constants.verticalSpaceSmall,
              ],
            )),
      ],
    );
  }
}
