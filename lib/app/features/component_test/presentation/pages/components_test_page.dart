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

class ComponentTest extends StatelessWidget {
  const ComponentTest({super.key});

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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TwoFooterButtons.addCancel(
            onAdd: () async => await BottomSheetDialog.showDraggableSheet(
              context,
              // child: const CloseRequestBottomSheetComponent(),
              child: DraggableSheetComponent(
                title: "اختتر",
                body: CustomEnhancedSheetDropDownWidget(
                  label: "المدينة",
                  items: List.generate(
                    30,
                    (index) => DropDownItem.byName(itemName: index.toString()),
                  ),
                  onSelected: (item) {},
                ),
              ),
            ),
            onCancel: () => MessageDialog.showSuccessNotification(msg: "Errr"),
          ),
          //! Buttons
          const CustomTextWidget("Buttons"),
          //* Space
          UIHelper.verticalSmallSpace,
          // TextButton
          CustomTextButtonWidget(
            text: "Text Button",
            btnEffectColor: Colors.cyan,
            // btnSize: const Size(100.0, 40.0),
            btnWidth: 150.0,
            btnHeight: 40.0,
            onPressed: () => BotToast.showSimpleNotification(title: "Welcome"),
          ),
          //* Space
          UIHelper.verticalSmallSpace,
          // TextButton+Icon
          CustomTextIconButtonWidget(
            text: "Text Button with Icon",
            btnEffectColor: Colors.cyan,
            // btnSize: const Size(250.0, 50.0),
            btnAlignment: MainAxisAlignment.spaceEvenly,
            btnWidth: 200.0,
            btnHeight: 50.0,
            icon: const Icon(Icons.warning_amber),
            iconTextTweenSpace: 12.0,
            iconAlignment: AlignmentDirectional.centerEnd,
            onPressed: () => BotToast.showSimpleNotification(title: "Welcome"),
          ),
          //* Space
          UIHelper.verticalSmallSpace,
          // ElevatedButton
          CustomElevatedButtonWidget(
            text: "Elevated Button",
            onPressed: () => BotToast.showSimpleNotification(title: "Welcome"),
          ),
          //* Space
          UIHelper.verticalSmallSpace,
          // StackElevatedButton+icon
          CustomElevatedStackIconButtonWidget(
            text: "Stack Elevated Button with Icon",
            icon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.access_alarm, color: Colors.white),
            ),
            iconAlignment: AlignmentDirectional.centerEnd,
            onPressed: () => BotToast.showSimpleNotification(title: "Welcome"),
          ),
          //* Space
          UIHelper.verticalSmallSpace,
          // ElevatedButton+icon
          CustomElevatedIconButtonWidget(
            text: "Elevated Button with Icon",
            icon: const Icon(Icons.access_alarm, color: Colors.white),
            iconTextTweenSpace: 12.0,
            iconAlignment: AlignmentDirectional.centerEnd,
            onPressed: () => BotToast.showSimpleNotification(title: "Welcome"),
          ),
          //* Space
          UIHelper.verticalSmallSpace,
          // IconButton
          CustomIconButtonWidget(
            backgroundColor: Colors.blue,
            icon: Icons.alarm,
            onPressed: () => BotToast.showText(
              text: "Welcome",
              clickClose: true,
            ),
          ),
          //* Space
          UIHelper.verticalSmallSpace,
          // UnderlineButton
          CustomUnderlineTextdButtonWidget(
            text: "Underline Button",
            onPressed: () => BotToast.showAnimationWidget(
              toastBuilder: (cancelFunc) => Container(
                height: 70.0,
                width: 70.0,
                color: Colors.amber,
              ),
              animationDuration: UIHelper.duration,
              clickClose: true,
            ),
          ),
          //* Space
          UIHelper.verticalLargeSpace,

          // Line
          const DrawLineWidget(),

          //* Space
          UIHelper.verticalMediumSpace,
          //! Buttons
          const CustomTextWidget("Radio Buttons"),
          //* Space
          UIHelper.verticalMediumSpace,
          // Radio Button
          CustomRadioButtonWidget(
            label: "Radio Button",
            radioValue: "Samir",
            radioGroupValue: "Samir",
            // btnWidth: 180.0,
            onSelected: (value) {},
          ),
          //* Space
          UIHelper.verticalMediumSpace,
          //! Dates
          const CustomTextWidget("Dates"),

          //* Space
          UIHelper.verticalMediumSpace,
          //! Files
          const CustomTextWidget("Files"),
          //
          CustomFilePickerWidget(
            label: "File",
            fileType: FileType.image,
            uploaded: false,
            onUploadAttachment: print,
            onRemoveAttachment: () {},
            onDeleteAttachment: () {},
            onDownloadAttachment: () {},
          ),
          CustomEnhancedFilePickerWidget(
            label: "File",
            fileType: FileType.image,
            uploaded: true,
            onUploadAttachment: print,
            onRemoveAttachment: () {},
            onDeleteAttachment: () {},
            onDownloadAttachment: () {},
          ),
          //* Space
          UIHelper.verticalMediumSpace,
          //! CheckBoxes
          const CustomTextWidget("CheckBox"),
          //* Space
          UIHelper.verticalSmallSpace,
          CustomCheckBoxWidget(
            selected: true,
            label: "Check1",
            onChanged: (state) {},
          ),
          UIHelper.verticalSmallSpace,
          CustomEnhancedCheckBoxWidget(
            selected: true,
            label: "Check1",
            onChanged: (state) {},
          ),
          UIHelper.verticalMediumSpace,
          //! CountryPicker
          const CustomTextWidget("CountryPicker"),
          //* Space
          UIHelper.verticalSmallSpace,
          CustomCountryPickerWidget(onSelected: (country) {}),
          UIHelper.verticalSmallSpace,
          CustomEnhancedCountryPickerWidget(onSelected: (country) => {}),
          UIHelper.verticalMediumSpace,
          //! DropDowns
          const CustomTextWidget("DropDowns"),
          //* Space
          UIHelper.verticalSmallSpace,
          CustomMaterialDropDownWidget(
            items: List.generate(
              3,
              (index) => DropDownItem.byName(itemName: index.toString()),
            ),
            onSelected: (item) {},
          ),
          //* Space
          UIHelper.verticalSmallSpace,
          CustomCupertinoDropDownWidget(
            items: List.generate(
              3,
              (index) => DropDownItem.byName(itemName: index.toString()),
            ),
            onSelected: (item) {},
          ),
          //* Space
          UIHelper.verticalSmallSpace,
          CustomPlatformDropDownWidget(
            items: List.generate(
              3,
              (index) => DropDownItem.byName(itemName: index.toString()),
            ),
            onSelected: (item) {},
          ),
          //* Space
          UIHelper.verticalSmallSpace,
          CustomEnhancedMaterialDropDownWidget(
            items: List.generate(
              3,
              (index) => DropDownItem.byName(itemName: index.toString()),
            ),
            onSelected: (item) {},
          ),
          //* Space
          UIHelper.verticalSmallSpace,
          CustomEnhancedCupertinoDropDownWidget(
            items: List.generate(
              3,
              (index) => DropDownItem.byName(itemName: index.toString()),
            ),
            onSelected: (item) {},
          ),
          //* Space
          UIHelper.verticalSmallSpace,
          CustomEnhancedPlatformDropDownWidget(
            items: List.generate(
              3,
              (index) => DropDownItem.byName(itemName: index.toString()),
            ),
            onSelected: (item) {},
          ),
          //* Space
          UIHelper.verticalSmallSpace,
          CustomSheetDropDownWidget(
            items: List.generate(
              30,
              (index) => DropDownItem.byName(itemName: index.toString()),
            ),
            onSelected: (item) {},
          ),
          //* Space
          UIHelper.verticalSmallSpace,
          CustomEnhancedSheetDropDownWidget(
            errorMsg: "Sam",
            label: "المدينة",
            items: List.generate(
              30,
              (index) => DropDownItem.byName(itemName: index.toString()),
            ),
            onSelected: (item) {},
          ),
          UIHelper.verticalMediumSpace,
          //! Date Picker
          const CustomTextWidget("Date Picker"),
          //* Space
          UIHelper.verticalSmallSpace,
          CustomMaterialDatePickerWidget(
            // initialDate: DateTime(2022, 10, 7),
            onSelected: (date) {},
          ),
          UIHelper.verticalSmallSpace,
          CustomCupertinoDatePickerWidget(
            // initialDate: DateTime(2022, 10, 7),
            onSelected: (date) {},
          ),
          UIHelper.verticalSmallSpace,
          CustomPlatformDatePickerWidget(
            // initialDate: DateTime(2022, 10, 7),
            onSelected: (date) {},
          ),
          UIHelper.verticalSmallSpace,
          CustomEnhancedMaterialDatePickerWidget(
            // initialDate: DateTime(2022, 10, 7),
            onSelected: (date) {},
          ),
          UIHelper.verticalSmallSpace,
          CustomEnhancedCupertinoDatePickerWidget(
            // initialDate: DateTime(2022, 10, 7),
            onSelected: (date) {},
          ),
          UIHelper.verticalSmallSpace,
          CustomEnhancedPlatformDatePickerWidget(
            // initialDate: DateTime(2022, 10, 7),
            onSelected: (date) {},
          ),

          UIHelper.verticalExtraSpace,
          UIHelper.verticalExtraSpace,
          UIHelper.verticalExtraSpace,
          UIHelper.verticalExtraSpace,
          UIHelper.verticalExtraSpace,
        ],
      ),
    );
  }
}
