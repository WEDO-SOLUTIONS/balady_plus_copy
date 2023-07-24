import 'package:flutter/material.dart';
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
                  const CRHeaderDesc(header: "بيانات المنشآه"),
                  const SizedBox(height: 16),
                  HorizontalRadioGroup(
                    groupName: 'بيانات موقع المنشأة',
                    currentItem: null,
                    items: [
                      RadioItem(radioValue: "داخل مبني", id: 1),
                      RadioItem(radioValue: "علي الشارع", id: 0),
                    ],
                    onChanged: (value) {},
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "طبيعه المبني",
                    marginBottom: 24,
                    onChangeType: (item) {},
                  ),
                  CustomTextFieldWidget(
                    label: "اسم المبني",
                    hintText: "ادخل اسم المبني",
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  const CustomTextFieldWidget(
                    label: "رفم الوحده",
                    hintText: "ادخل رفم الوحده",
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                  ),
                  const CustomTextFieldWidget(
                    label: "الطابق",
                    hintText: "ادخل الطابق",
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                  ),
                  CustomTextFieldWidget(
                    label: "ارشادات الوصول من البوابة الرئيسية",
                    maxLines: 3,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  const CustomTextFieldWidget(
                    label: "رقم المبني",
                    hintText: "ادخل رقم المبني",
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                  ),
                  const CustomTextFieldWidget(
                    label: "الرقم الاضافي",
                    hintText: "ادخل الرقم الاضافي",
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                  ),
                  const CustomTextFieldWidget(
                    label: "الرمز البريدي",
                    hintText: "ادخل الرمز البريدي",
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

