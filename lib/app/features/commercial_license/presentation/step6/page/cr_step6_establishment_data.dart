import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';

class CRStep6EstablishmentData extends StatelessWidget {
  const CRStep6EstablishmentData({Key? key}) : super(key: key);

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
                  CRHeaderDesc(header: "step6title".tr()),
                  const SizedBox(height: 16),
                  HorizontalRadioGroup(
                    groupName: 'step6groupName'.tr(),
                    currentItem: null,
                    items: [
                      RadioItem(radioValue: "step6Ratio1".tr(), id: 1),
                      RadioItem(radioValue: "step6Ratio2".tr(), id: 0),
                    ],
                    onChanged: (value) {},
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "step6building".tr(),
                    marginBottom: 24,
                    onChangeType: (item) {},
                  ),
                  CustomTextFieldWidget(
                    label: "step6Buildingname".tr(),
                    hintText: "step6buildingNameEntry".tr(),
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: "step6groupNumber".tr(),
                    hintText: "step6groupEnterNumber".tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                  ),
                  CustomTextFieldWidget(
                    label: "step6floor".tr(),
                    hintText: "step6EnterFloor".tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                  ),
                  CustomTextFieldWidget(
                    label: 'step6DoorTrack'.tr(),
                    maxLines: 3,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: 'step6buildingNumber'.tr(),
                    hintText: 'step6buildingNumberEntry'.tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                  ),
                  CustomTextFieldWidget(
                    label: 'step6AdditionNumber'.tr(),
                    hintText: 'step6AdditionEntry'.tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                  ),
                  CustomTextFieldWidget(
                    label: 'step6Email'.tr(),
                    hintText: 'step6EmailEntry'.tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                  ),
                  const OwnerInfoCard(),
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
