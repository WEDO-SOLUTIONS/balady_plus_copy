import 'package:flutter/material.dart';
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
                  const CRHeaderDesc(header: "البيانات الاضافية والمرفقات"),
                  const SizedBox(height: 16),
                  YesNoRadioGroupWidget(
                    groupName: "هل يوجد لديك قنوات دفع ؟",
                    onChanged: (value) {},
                  ),
                  const CustomTextWidget(
                    "هل يوجد لديك قنوات دفع ؟",
                    fontWeight: AppFontWeight.bold,
                    fontSize: 16,
                    fontColor: AppColor.blackModern700Light,
                  ),
                  const SizedBox(height: 16),
                  CheckBoxWithTitle(
                    title: "مدى",
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  CheckBoxWithTitle(
                    title: "فيزا",
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  CheckBoxWithTitle(
                    title: "امريكان اكسبرس",
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  CheckBoxWithTitle(
                    title: "ماستر كارد",
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  CheckBoxWithTitle(
                    title: "Apple Pay",
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 24),
                  const CustomTextWidget(
                    "اختر كل ما ينطبق على المنشأة",
                    fontWeight: AppFontWeight.bold,
                    fontSize: 16,
                    fontColor: AppColor.blackModern700Light,
                  ),
                  const SizedBox(height: 16),
                  CheckBoxWithTitle(
                    title: "يوجد مكان خارجي قابل للاستثمار",
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  CheckBoxWithTitle(
                    title: "يخدم الموقع الوصول لذوي الاحتياجات الخاصة",
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  CheckBoxWithTitle(
                    title: "توجد مواقف مخصصة للمنشأة",
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 24),
                  CustomTextFieldWidget(
                    label: "عدد المواقف",
                    hintText: "ادخل عدد المواقف",
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  CheckBoxWithTitle(
                    title: "تتوفر خدمة البيع الالكتروني",
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  CheckBoxWithTitle(
                    title: "تتوفر خدمة التوصيل",
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  CheckBoxWithTitle(
                    title: "تتوفر خدمة صف المركبات",
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  CustomTextFieldWidget(
                    label: "رقم اشتراك الكهرباء",
                    hintText: "ادخل رقم اشتراك الكهرباء",
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: "الرقم اشتراك المياه",
                    hintText: "ادخل الرقم اشتراك المياه",
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  PickFileComponent(
                    title: "صورة المحل الخارجية",
                    file: null,
                    onDelete: () {},
                    onPickedFile: (file) {},
                  ),
                  PickFileComponent(
                    title: "صورة المحل الداخلية",
                    file: null,
                    onDelete: () {},
                    onPickedFile: (file) {},
                  ),
                  PickFileComponent(
                    title: "صورة الخدمات والمنتجات",
                    file: null,
                    onDelete: () {},
                    onPickedFile: (file) {},
                  ),
                  PickFileComponent(
                    title: "صورة البانر",
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
