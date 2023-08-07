import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';
import '../../../commercial_license_exports.dart';

class CRStep8EmployeeData extends StatelessWidget {
  const CRStep8EmployeeData({Key? key}) : super(key: key);

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
                  CRHeaderDesc(
                    header: 'step8title'.tr(),
                  ),
                  const SizedBox(height: 16),
                  HorizontalRadioGroup(
                    groupName: 'step6groupName'.tr(),
                    currentItem: null,
                    items: [
                      RadioItem(radioValue: 'step6Ratio1'.tr(), id: 1),
                      RadioItem(radioValue: 'step6Ratio2'.tr(), id: 1),
                    ],
                    onChanged: (value) {},
                  ),
                  CustomTextWidget(
                    "workers".tr(),
                    fontSize: 16,
                    fontColor: AppColor.blackModern700Light,
                    fontWeight: AppFontWeight.bold,
                  ),
                  const SizedBox(height: 16),
                  PlusAddButton(
                    onPressed: () => BottomSheetDialog.showDraggableSheet(
                      context,
                      child: BottomSheetWithActions(
                        title: "addWorker".tr(),
                        action: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButtonWidget.add(onPressed: () {}),
                        ),
                        body: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomTextFieldWidget(
                              label: "owner_id".tr(),
                              hintText: 'id_entry'.tr(),
                              isDigitsOnly: true,
                              keyboardType: TextInputType.number,
                              bottomMargin: 24,
                              onChanged: (value) {},
                            ),
                            HijriCalendarAddetionalField(
                              fieldName: "birth".tr(),
                              isMandatory: true,
                              onChanged: (date) {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    text: "addWorker".tr(),
                  ),
                  const SizedBox(height: 24),
                  const EmployeeInfoCard(),
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: AppColor.primary50Light,
                    ),
                    child: CheckBoxWithTitle(
                      title: 'workerDesc'.tr(),
                      onChanged: (value) {},
                    ),
                  ),
                  CustomTextFieldWidget(
                    label: 'step6AdditionNumber'.tr(),
                    hintText: 'step6AdditionEntry'.tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: 'step6Email'.tr(),
                    hintText: 'step6EmailEntry'.tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                    onChanged: (value) {},
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
