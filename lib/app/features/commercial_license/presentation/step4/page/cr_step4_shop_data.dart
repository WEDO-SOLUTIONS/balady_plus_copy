import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';
import '../../../commercial_license_exports.dart';

class CRStep4ShopData extends StatelessWidget {
  const CRStep4ShopData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CRHeaderDesc(header: 'step4Title'.tr()),
                  const SizedBox(height: 16),
                  YesNoRadioGroupWidget(
                    groupName: 'step4GroupName'.tr(),
                    currentValue: null,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: 'step6label1'.tr(),
                    hintText: 'step6hint1'.tr(),
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: 'step6label2'.tr(),
                    hintText: 'step6hint2'.tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: 'step6label3'.tr(),
                    hintText: 'step6hint3'.tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: 'step4label4'.tr(),
                    hintText: 'step4hint4'.tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: 'step4label5'.tr(),
                    hintText: 'step4hint5'.tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: 'step4label6'.tr(),
                    hintText: 'step4hint6'.tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  UndertakingWidget(
                    text: 'step4text'.tr(),
                    desc: 'step4desc'.tr(),
                    onChange: (value) {},
                    initialValue: false,
                  ),
                  YesNoRadioGroupWidget(
                    groupName: 'step4groupName1'.tr(),
                    currentValue: null,
                    onChanged: (value) {},
                  ),
                  YesNoRadioGroupWidget(
                    groupName: 'step4groupName2'.tr(),
                    currentValue: null,
                    onChanged: (value) {},
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: 'step4label7'.tr(),
                    marginBottom: 24,
                    onChangeType: (item) {},
                  ),
                  CustomTextFieldWidget(
                    label: 'step4label8'.tr(),
                    hintText: 'step4hint8'.tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                  ),
                  YesNoRadioGroupWidget(
                    groupName: 'step4groupName3'.tr(),
                    currentValue: null,
                    onChanged: (value) {},
                  ),
                  YesNoRadioGroupWidget(
                    groupName: 'step4groupName4'.tr(),
                    currentValue: null,
                    onChanged: (value) {},
                  ),
                  HorizontalRadioGroup(
                    groupName: 'step4groupName5'.tr(),
                    currentItem: null,
                    items: [
                      RadioItem(radioValue: "owner_card".tr(), id: 1),
                      RadioItem(radioValue: "renter".tr(), id: 0),
                    ],
                    onChanged: (value) {},
                  ),
                  HorizontalRadioGroup(
                    groupName: 'municipalAdvisorContractType'.tr(),
                    currentItem: null,
                    items: [
                      RadioItem(radioValue: "ratio1".tr(), id: 1),
                    ],
                    onChanged: (value) {},
                  ),
                  HorizontalRadioGroup(
                    groupName: 'contractEntry'.tr(),
                    currentItem: null,
                    items: [
                      RadioItem(radioValue: "fileUpload".tr(), id: 1),
                      RadioItem(radioValue: "contractNumberEntry".tr(), id: 1),
                    ],
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: 'owningContractNumber'.tr(),
                    hintText: 'owningContractEntry'.tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                  ),
                  HijriCalendarAddetionalField(
                    fieldName: 'contractDate'.tr(),
                    isMandatory: true,
                    onChanged: (value) {},
                  ),
                  HorizontalRadioGroup(
                    groupName: 'municipalAdvisorBoards'.tr(),
                    currentItem: null,
                    items: [
                      RadioItem(radioValue: 'contractLicense'.tr(), id: 1),
                      RadioItem(radioValue: 'contractAddition'.tr(), id: 1),
                    ],
                    onChanged: (value) {},
                  ),
                  const BillboardComponent(),
                  NotesWidget(
                    notes: [
                      'note5'.tr(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const CRPreviousNextButtons(isBtnDisabled: false),
      ],
    );
  }
}
