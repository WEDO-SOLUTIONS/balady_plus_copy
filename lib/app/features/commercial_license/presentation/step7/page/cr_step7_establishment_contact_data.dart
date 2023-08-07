import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
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
                  CRHeaderDesc(header: 'step7Ttitle'.tr()),
                  const SizedBox(height: 16),
                  CustomTextFieldWidget(
                    label: 'managerId'.tr(),
                    hintText: "managerEntry".tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                  ),
                  HijriCalendarAddetionalField(
                    fieldName: "birth".tr(),
                    isMandatory: true,
                    onChanged: (date) {},
                  ),
                  ElevatedButtonWidget.verify(onPressed: () {}),
                  const SizedBox(height: 24),
                  const ManagerInfoCard(),
                  TextWithCheckBtn(
                    controller: TextEditingController(),
                    title: "user_data_applicant_mobile".tr(),
                    hint: "number_entry".tr(),
                    validate: (String? t) {},
                    isValidate: false,
                    currentValue: null,
                    onTextChanged: (String text) {},
                    verify: () {},
                  ),
                  NotesWidget(
                    notes: ['note4'.tr()],
                  ),
                  CustomTextFieldWidget(
                    label: "owner_email".tr(),
                    hintText: "enter_email".tr(),
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: "phone".tr(),
                    hintText: "phoneEntry".tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                  ),
                  CustomTextFieldWidget(
                    label: 'step7label1'.tr(),
                    hintText: 'step7hint1'.tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                  ),
                  CustomTextFieldWidget(
                    label: "website".tr(),
                    hintText: "websiteEntry".tr(),
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: 'twitterAccount'.tr(),
                    hintText: 'twitterEntry'.tr(),
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: 'instaAccount'.tr(),
                    hintText: 'instaEntry'.tr(),
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: 'snapChatAccount'.tr(),
                    hintText: 'snapChatENtry'.tr(),
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: 'facebookAccount'.tr(),
                    hintText: 'facebookEntry'.tr(),
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: 'whatsappAccount'.tr(),
                    hintText: 'whatsappEntry'.tr(),
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
