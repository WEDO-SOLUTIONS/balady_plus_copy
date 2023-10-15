import 'package:balady_plus/app/features/commercial_license/presentation/step4/bloc/cr_step4_shop_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';
import '../../../commercial_license_exports.dart';
import '../../step3/bloc/map_bloc.dart';

class CRStep4ShopData extends StatelessWidget {
  const CRStep4ShopData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrStep4ShopDataCubit, CrStep4ShopDataState>(
        builder: (context, state) {
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
                    const CRHeaderDesc(header: "بيانات المحل واللوحات"),
                    const SizedBox(height: 16),
                    YesNoRadioGroupWidget(
                      groupName: 'هل يوجد لديك علامة تجارية ؟',
                      currentValue: null,
                      onChanged: (value) {},
                    ),
                    CustomTextFieldWidget(
                      label: "اسم المحل",
                      hintText: "ادخل اسم المحل",
                      bottomMargin: 24,
                      onChanged: (value) {},
                    ),
                    CustomTextFieldWidget(
                      label: "رقم المحل",
                      hintText: "ادخل رقم المحل",
                      isDigitsOnly: true,
                      keyboardType: TextInputType.number,
                      bottomMargin: 24,
                      onChanged: (value) {},
                    ),
                    CustomTextFieldWidget(
                      label: "رقم العقار",
                      hintText: "ادخل رقم العقار",
                      isDigitsOnly: true,
                      keyboardType: TextInputType.number,
                      bottomMargin: 24,
                      onChanged: (value) {},
                    ),
                    CustomTextFieldWidget(
                      label: "عدد الفتحات",
                      hintText: "ادخل عدد الفتحات",
                      isDigitsOnly: true,
                      keyboardType: TextInputType.number,
                      bottomMargin: 24,
                      onChanged: (value) {},
                    ),
                    CustomTextFieldWidget(
                      label: "عدد الادوار في المحل",
                      hintText: "ادخل عدد الادوار في المحل",
                      isDigitsOnly: true,
                      keyboardType: TextInputType.number,
                      bottomMargin: 24,
                      onChanged: (value) {},
                    ),
                    CustomTextFieldWidget(
                      label: "عدد الكاميرات في المحل",
                      hintText: "ادخل عدد الكاميرات في المحل",
                      isDigitsOnly: true,
                      keyboardType: TextInputType.number,
                      bottomMargin: 24,
                      onChanged: (value) {},
                    ),
                    UndertakingWidget(
                      text: "أتعهد على جميع ماتم ذكره اعلاه",
                      desc:
                          "اتعهد انا (احمد بن خالد) بالإقرار على تركيب كاميرات مراقبة   وفقا لاشتراطات الجهة المعنية",
                      onChange: (value) {},
                      initialValue: false,
                    ),
                    YesNoRadioGroupWidget(
                      groupName: 'هل يوجد مصعد في المحل ؟',
                      currentValue: null,
                      onChanged: (value) {},
                    ),
                    YesNoRadioGroupWidget(
                      groupName: 'هل يقع المحل في مركز تجاري ؟',
                      currentValue: null,
                      onChanged: (value) {},
                    ),
                    CustomTapWidgetForLongDialog(
                      items: const [],
                      value: null,
                      label: "المركز التجاري",
                      marginBottom: 24,
                      onChangeType: (item) {},
                    ),
                    const CustomTextFieldWidget(
                      label: "الطابق",
                      hintText: "ادخل الطابق",
                      isDigitsOnly: true,
                      keyboardType: TextInputType.number,
                      bottomMargin: 24,
                    ),
                    YesNoRadioGroupWidget(
                      groupName: 'هل انت متعاقد مع احدى شركات النظافة ؟',
                      currentValue: null,
                      onChanged: (value) {},
                    ),
                    YesNoRadioGroupWidget(
                      groupName: 'هل لديك تصريح سلامة ؟',
                      currentValue: null,
                      onChanged: (value) {},
                    ),
                    HorizontalRadioGroup(
                      groupName: 'صفة المقدم بالنسبة لموقع المحل',
                      currentItem: null,
                      items: [
                        RadioItem(radioValue: "مالك", id: 1),
                        RadioItem(radioValue: "مستاجر", id: 0),
                      ],
                      onChanged: (value) {},
                    ),
                    HorizontalRadioGroup(
                      groupName: 'نوع العقد',
                      currentItem: null,
                      items: [
                        RadioItem(radioValue: "عقد تملك المبنى (صك)", id: 1),
                      ],
                      onChanged: (value) {},
                    ),
                    HorizontalRadioGroup(
                      groupName: 'طريقة ادخال العقد',
                      currentItem: null,
                      items: [
                        RadioItem(radioValue: "ارفاق ملف", id: 1),
                        RadioItem(radioValue: "رقم عقد الصك الالكتروني", id: 1),
                      ],
                      onChanged: (value) {},
                    ),
                    const CustomTextFieldWidget(
                      label: "رقم عقد التملك",
                      hintText: "ادخل رقم عقد التملك",
                      isDigitsOnly: true,
                      keyboardType: TextInputType.number,
                      bottomMargin: 24,
                    ),
                    HijriCalendarAddetionalField(
                      fieldName: 'تاريخ عقد التملك',
                      isMandatory: true,
                      onChanged: (value) {},
                    ),
                    HorizontalRadioGroup(
                      groupName: 'اللوحات',
                      currentItem: null,
                      items: [
                        RadioItem(radioValue: "اضافه عقد لوحه", id: 1),
                        RadioItem(radioValue: "اضافه بيانات اللوحه", id: 1),
                      ],
                      onChanged: (value) {},
                    ),
                    const BillboardComponent(),
                    const NotesWidget(
                      notes: [
                        "عزيزي المستفيد, يمكنك الاطلاع على إرشادات اللوحات"
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
    });
  }
}
