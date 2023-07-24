import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';
import 'package:flutter/material.dart';
import '../../../../_shared_feature_/presentation/widgets/check_boxes/text_field_with_check_btn.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';

class CRStep7EstablishmentContactData extends StatelessWidget {
  const CRStep7EstablishmentContactData({Key? key}) : super(key: key);

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
                  const CRHeaderDesc(header: "بيانات تواصل المنشأة"),
                  const SizedBox(height: 16),
                  const CustomTextFieldWidget(
                    label: "هويه مدير الموقع",
                    hintText: "ادخل هويه مدير الموقع",
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                  ),
                  HijriCalendarAddetionalField(
                    fieldName: "تاريخ الميلاد",
                    isMandatory: true,
                    onChanged: (date) {},
                  ),
                  ElevatedButtonWidget.verify(onPressed: () {}),
                  const SizedBox(height: 24),
                  const ManagerInfoCard(),
                  TextWithCheckBtn(
                    controller: TextEditingController(),
                    title: "رقم الجوال",
                    hint: "ادخل رقم الجوال",
                    validate: (String? t) {},
                    isValidate: false,
                    currentValue: null,
                    onTextChanged: (String text) {},
                    verify: () {},
                  ),
                  const NotesWidget(
                    notes: [
                      "سوف يتم استلام جميع الاشعارات على رقم الجوال المسجل في النظام"
                    ],
                  ),
                  CustomTextFieldWidget(
                    label: "البريد الالكتروني",
                    hintText: "ادخل البريد الالكتروني",
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  const CustomTextFieldWidget(
                    label: "هاتف المنشاه",
                    hintText: "ادخل هاتف المنشاه",
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                  ),
                  const CustomTextFieldWidget(
                    label: "رقم خدمه العملاء",
                    hintText: "ادخل رقم خدمه العملاء",
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                  ),
                  CustomTextFieldWidget(
                    label: "الموقع الالكتروني",
                    hintText: "ادخل الموقع الالكتروني",
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: "حساب توبتر",
                    hintText: "ادخل حساب توبتر",
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: "حساب انستجرام",
                    hintText: "ادخل حساب انستجرام",
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: "حساب سناب شات",
                    hintText: "ادخل حساب سناب شات",
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: "حساب فيس بوك",
                    hintText: "ادخل حساب فيس بوك",
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  const CustomTextFieldWidget(
                    label: "رقم الواتساب",
                    hintText: "ادخل رقم الواتساب",
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
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
