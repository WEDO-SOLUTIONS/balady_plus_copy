import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';

class CRStep10AdditionalData extends StatelessWidget {
  const CRStep10AdditionalData({Key? key}) : super(key: key);

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
                  CRHeaderDesc(header: 'step10title'.tr()),
                  const SizedBox(height: 16),
                  YesNoRadioGroupWidget(
                    groupName: 'step10groupName1'.tr(),
                    onChanged: (value) {},
                  ),
                  CustomTextWidget(
                    'step10groupName1'.tr(),
                    fontWeight: AppFontWeight.bold,
                    fontSize: 16,
                    fontColor: AppColor.blackModern700Light,
                  ),
                  const SizedBox(height: 16),
                  CheckBoxWithTitle(
                    title: "mada".tr(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  CheckBoxWithTitle(
                    title: "visa".tr(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  CheckBoxWithTitle(
                    title: "americanExpress".tr(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  CheckBoxWithTitle(
                    title: 'masterCard'.tr(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  CheckBoxWithTitle(
                    title: "Apple Pay",
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 24),
                  CustomTextWidget(
                    'chooseDesc'.tr(),
                    fontWeight: AppFontWeight.bold,
                    fontSize: 16,
                    fontColor: AppColor.blackModern700Light,
                  ),
                  const SizedBox(height: 16),
                  CheckBoxWithTitle(
                    title: 'step10check1'.tr(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  CheckBoxWithTitle(
                    title: 'step10check2'.tr(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  CheckBoxWithTitle(
                    title: 'step10check3'.tr(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 24),
                  CustomTextFieldWidget(
                    label: 'step10label1'.tr(),
                    hintText: 'step10hint1'.tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  CheckBoxWithTitle(
                    title: 'step10check4'.tr(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  CheckBoxWithTitle(
                    title: 'step10check5'.tr(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  CheckBoxWithTitle(
                    title: 'step10check6'.tr(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  CustomTextFieldWidget(
                    label: 'step10label2'.tr(),
                    hintText: 'step10hint2'.tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: 'step10label3'.tr(),
                    hintText: 'step10hint3'.tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  PickFileComponent(
                    title: 'step10pick1'.tr(),
                    file: null,
                    onDelete: () {},
                    onPickedFile: (file) {},
                  ),
                  PickFileComponent(
                    title: 'step10pick2'.tr(),
                    file: null,
                    onDelete: () {},
                    onPickedFile: (file) {},
                  ),
                  PickFileComponent(
                    title: 'step10pick3'.tr(),
                    file: null,
                    onDelete: () {},
                    onPickedFile: (file) {},
                  ),
                  PickFileComponent(
                    title: 'step10pick4'.tr(),
                    file: null,
                    onDelete: () {},
                    onPickedFile: (file) {},
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
