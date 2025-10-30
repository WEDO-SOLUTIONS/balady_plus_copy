import '../../../../core/services/local/navigation_services.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/features/self_rate/self_rate.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import '/app/features/shared_features/widgets/custom_text_component.dart';
import '/app/core/utils/constants/language.dart';
import 'package:flutter/material.dart';

class SelfEvaluation extends StatelessWidget {
  const SelfEvaluation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomTextComponent(
            text: 'القاء مخالفات البناء خارج حدود المحطه'),
        const CustomTextComponent(
            text: 'الالتزام بنظام اجراءات التراخيص البلدية ولائحته التنفيذية'),
        const CustomTextComponent(
            text:
                'وضع ترخيص النشاط في مكان بارز بالمحل ويمنع استخدامه لغير الغرض الذي خصص من أجله. 2024-01-28 '),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 168,
          // width: 361,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            image: const DecorationImage(
              image: AssetImage(
                  "packages/smart_advisor/smart_advisor_assets/images/evaluBackg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 18, left: 76.5, right: 28, bottom: 19),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'التقييم الذاتي',
                  style: AppStyle.calloutBoldStyle
                      .copyWith(color: AppColor.textPrimaryColor),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'أبدء التقييم الذاتي لمعرفة مدى امتثالك للاشتراطات البلدية .',
                  style: AppStyle.footNoteRomanStyle
                      .copyWith(color: AppColor.textSecondaryColor),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  btnWidth: 173,
                  btnHeight: 43,
                  btnColor: AppColor.statusAccentColor,
                  onPress: () {
                    NavigationService.navigatorKey.currentState!
                        .push(MaterialPageRoute(builder: (ctx) {
                      return const SelfRate();
                    }));
                  },
                  text: ("evaluate").tr(),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
