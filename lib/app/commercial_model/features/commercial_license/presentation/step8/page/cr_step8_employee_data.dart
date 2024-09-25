import 'package:flutter/material.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';
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
                  const CRHeaderDesc(header: "بيانات العاملين"),
                  const SizedBox(height: 16),
                  HorizontalRadioGroup(
                    groupName: 'بيانات موقع المنشأة',
                    currentItem: null,
                    items: [
                      //    RadioItem(radioValue: "داخل مبني", id: 1),
                      //    RadioItem(radioValue: "علي الشارع", id: 1),
                    ],
                    onChanged: (value) {},
                  ),
                  const CustomTextWidget(
                    "العاملين",
                    fontSize: 16,
                    fontColor: AppColor.blackModern700Light,
                    fontWeight: AppFontWeight.bold,
                  ),
                  const SizedBox(height: 16),
                  PlusAddButton(
                    onPressed: () => BottomSheetDialog.showDraggableSheet(
                      context,
                      child: BottomSheetWithActions(
                        title: "اضافة عامل",
                        action: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButtonWidget.add(onPressed: () {}),
                        ),
                        body: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomTextFieldWidget(
                              label: "رقم الهوية",
                              hintText: "ادخل رقم الهوية",
                              isDigitsOnly: true,
                              keyboardType: TextInputType.number,
                              bottomMargin: 24,
                              onChanged: (value) {},
                            ),
                            HijriCalendarAddetionalField(
                              fieldName: "تاريخ الميلاد",
                              isMandatory: true,
                              onChanged: (date) {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    text: "اضافه عامل",
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
                      title: "اتعهد انه تم تسجيل جميع العاملين في المحل",
                      onChanged: (value) {},
                    ),
                  ),
                  CustomTextFieldWidget(
                    label: "الرقم الاضافي",
                    hintText: "ادخل الرقم الاضافي",
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: "الرمز البريدي",
                    hintText: "ادخل الرمز البريدي",
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
