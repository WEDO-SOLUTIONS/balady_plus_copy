import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, UIHelper;
import '../../../_shared_feature_/presentation/widgets/pickers/custom_file_picker_widget.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        CustomCheckBoxWidget,
        CustomCountryPickerWidget,
        CustomCupertinoDatePickerWidget,
        CustomCupertinoDropDownWidget,
        CustomElevatedButtonWidget,
        CustomElevatedIconButtonWidget,
        CustomElevatedStackIconButtonWidget,
        CustomEnhancedCheckBoxWidget,
        CustomEnhancedCountryPickerWidget,
        CustomEnhancedCupertinoDatePickerWidget,
        CustomEnhancedCupertinoDropDownWidget,
        CustomEnhancedFilePickerWidget,
        CustomEnhancedHijriDatePickerWidget,
        CustomEnhancedMaterialDatePickerWidget,
        CustomEnhancedMaterialDropDownWidget,
        CustomEnhancedPlatformDatePickerWidget,
        CustomEnhancedPlatformDropDownWidget,
        CustomEnhancedSheetDropDownWidget,
        CustomHijriDatePickerWidget,
        CustomIconButtonWidget,
        CustomMaterialDatePickerWidget,
        CustomMaterialDropDownWidget,
        CustomPlatformDatePickerWidget,
        CustomPlatformDropDownWidget,
        CustomRadioButtonWidget,
        CustomSheetDropDownWidget,
        CustomTextButtonWidget,
        CustomTextIconButtonWidget,
        CustomTextWidget,
        CustomUnderlineTextdButtonWidget,
        DraggableSheetComponent,
        DrawLineWidget,
        DropDownItem,
        MessageDialog,
        TwoFooterButtons;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomTextWidget(
          "home".tr(),
          textStyle:
              AppStyle.mainTextSecondaryStyle.copyWith(color: AppColor.white),
        ),
      ),
      body: Center(
        child: CustomTextWidget("more".tr()),
      ),
    );
  }
}
