import '/app/core/utils/constants/app_colors.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/general_items_dialog.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import '/app/features/shared_features/widgets/custom_text_component.dart';
import 'package:flutter/material.dart';
import '/app/core/utils/constants/language.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/genral_cond_delg.dart';

class GeneralConditionsWidget extends StatelessWidget {
  final List<String> items;
  final String title;

  const GeneralConditionsWidget(
      {super.key, required this.items, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length > 3 ? 3 : items.length,
              itemBuilder: (ctx, index) {
                return CustomTextComponent(text: items[index]);
              }),
        ),
        /* CustomButton(
          btnColor: AppColor.surfaceAccentSecondaryColor,
          textColor: AppColor.statusAccentColor,
          onPress: () {
            showModalBottomSheet(
              backgroundColor: const Color(0xff000000),
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) => GeneralItemsDialog(
                title: title,
                items: items,
              ),
            );
          },
          text: ("all_requirements").tr(),
        ),*/
      ],
    );

    /*  return Column(
      children: [
        const CustomTextComponent(text: "سجل تجاري للنشاط  "),
        const CustomTextComponent(
            text: 'الالتزام بنظام اجراءات التراخيص البلدية ولائحته التنفيذية'),
        const CustomTextComponent(
            text:
                'تطبيق متطلبات ذوي الاحتياجات الخاصة في تصميم منشآت المحطة ومركز الخدمة وفقا للاشتراطات الخاصة بالخدمات البلدية المتعلقة بذوي الاحتياجات الخاصة الصادرة من الوزارة.'),
      ],
    );*/
  }
}
