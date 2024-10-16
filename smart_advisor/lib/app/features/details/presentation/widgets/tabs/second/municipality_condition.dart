import '/app/features/shared_features/widgets/custom_icon_text.dart';
import '/app/features/shared_features/widgets/text_point.dart';
import 'package:flutter/material.dart';

class MunicipalityCondition extends StatelessWidget {
  const MunicipalityCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                TextPoint(
                    textOne:
                        'توفير شاشات إلكترونية كبيرة وواضحة على مداخل محطات البنزين بكافة أنواعها داخل المدن وخارجها تبين أسعار الوقود .',
                    textTow:
                        'يجب توفير وسيلة للدفع الالكتروني قبل ممارسة النشاط'),
                CustomIconText(
                    text:
                        'اشتراطات اللائحة التنفيذية للمواصفات والمقاييس لمضخات الوقود '),
                CustomIconText(text: 'المهلة التصحيحية للمحطات القائمة'),
                CustomIconText(text: 'اشتراطات اللوحات التجارية')
              ],
            ),
          ],
        ),
      ],
    );
  }
}
