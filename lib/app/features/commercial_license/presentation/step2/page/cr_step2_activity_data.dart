import 'package:flutter/material.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';

class CRStep2ActivityData extends StatelessWidget {
  const CRStep2ActivityData({Key? key}) : super(key: key);

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
                  const CRHeaderDesc(header: "بيانات النـشاط"),
                  const SizedBox(height: 12),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "شاط أيزيك",
                    marginBottom: 8,
                    onChangeType: (item) {},
                  ),
                  const NotesWidget(
                    notes: [
                      "عزيزي المستفيد, يرجى اختيار النشاط المطابق للنشاط الفعلي للمحل، حيث أنه لا يمكن تعديل نشاط الرخصة بعد اصدارها.",
                      "تأكد من وجود ترخيص لأي عامل حرفي في منشأتك حيث انه شرط أساسي لإصدار او تجديد الرخص التجارية"
                    ],
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "النشاط التفصيلي",
                    marginBottom: 8,
                    onChangeType: (item) {},
                  ),
                  const NotesWidget(
                    notes: [
                      "عزيزي المستفيد, يمكنك الاستعلام عن تفاصيل الأنشطة التجارية واشتراطاتها من خلال زيارتك للرابط التالي:\n الأنشطة التجارية واشتراطاته"
                    ],
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "نوع المنشاه",
                    marginBottom: 24,
                    onChangeType: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: "المساحه الكليه للمحل",
                    hintText: "ادخل المساحه الكليه للمحل",
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    suffixIcon: const CustomTextWidget(
                      "متر  مربع",
                      fontSize: 12,
                      fontWeight: AppFontWeight.semiBold,
                      fontColor: AppColor.blackModern400Light,
                    ),
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  WorkerTypeComponent(
                    selectedWorkerType: null,
                    onSelectedType: (type) {},
                  ),
                  const ExtraActivityComponent(),

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

