import '/app/core/utils/constants/app_colors.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/genral_cond_delg.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import '/app/features/shared_features/widgets/custom_text_component.dart';
import 'package:flutter/material.dart';
import '/app/core/utils/constants/language.dart';

class LocationCondition extends StatelessWidget {
  const LocationCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomTextComponent(text: 'الاتقل مساحة الموقع عن 1500م2'),
        const CustomTextComponent(
            text:
                'يشترط أن لا تقل مساحة الفتحات عن 1/8 المساحة المبنية من النشاط.'),
        const CustomTextComponent(
            text:
                'أن يكون الموقع داخل مخططات الورش أو المناطق الصناعية المعتمدة ضمن المخططات الهيكلية للمدن والقرى.'),
        CustomButton(
          btnColor: AppColor.surfaceAccentSecondaryColor,
          textColor: AppColor.statusAccentColor,
          onPress: () {
            showModalBottomSheet(
              backgroundColor: const Color(0xff000000),
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) => GenralCondDelg(),
            );
          },
          text: ("all_requirements").tr(),
        ),
      ],
    );
  }
}
