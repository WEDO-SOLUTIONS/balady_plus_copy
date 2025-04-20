import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/features/home_page/presentation/pages/new_home_page.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/renewal_terms_card.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/terms_with_steper.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/widgets/button_bottom.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:url_launcher/url_launcher.dart';

class CancelLicensePage extends StatelessWidget {
  const CancelLicensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "رحلتك لإلغاء رخصتك",
                        style: AppStyle.somarSemiBold.copyWith(
                            color: AppColor.textPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const RenewalTermsCard(
                      number: 1,
                      title: "هل أنت متأكد من الإلغاء؟",
                      description:
                          "إذا كنت ترغب في تغيير نشاطك التجاري أو نقل الملكية، فلا حاجة لإلغاء الرخصة الحالية. يمكنك التعرف على الخيارات المتاحة لتعديل رخصتك من خلال دليلنا المفصل الذي يوضح الخطوات اللازمة قبل اتخاذ قرار الإلغاء.",
                      listOfTerms: [],
                      iconPath: IconPath.warning,
                      hasIcon: false,
                      isBasicColor: false,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TermsWithSteper(
                      number: 2,
                      title: "الغاء رخصتك التجارية",
                      description:
                          "وفقًا للإجراءات المحددة، ستحتاج إلى اتباع الخطوات لإتمام الخدمة.",
                      titleTerms: "تمر خطوة الغاء الرخصة بعدة مراحل:",
                      steps: [
                        StepData(
                          title: 'تسجيل الدخول إلى "بلدي"',
                          icon: IconPath.note,
                        ),
                        StepData(
                          title: 'تحديد الرخصة لالغاء',
                          icon: IconPath.editing,
                        ),
                        StepData(
                          title: 'تقديم الطلب',
                          icon: IconPath.note_blank,
                        ),
                        StepData(
                          title: ' إصدار الفاتورة',
                          icon: IconPath.purchased,
                        ),
                        StepData(
                          title: 'دفع رسوم الخدمة',
                          icon: IconPath.finance,
                          //  isCalculator: true,
                        ),
                      ],
                      renewTitleText: "هل أنت مستعد لالغاء رخصتك؟",
                      renewDescriptionText: "الذهاب الى خدمة الغاء رخصة تجارية",
                      onPress: () {
                        launchUrl(Uri.parse(
                            "https://balady.gov.sa/ar/services/%D8%A5%D9%84%D8%BA%D8%A7%D8%A1-%D8%B1%D8%AE%D8%B5%D8%A9-%D9%86%D8%B4%D8%A7%D8%B7-%D8%AA%D8%AC%D8%A7%D8%B1%D9%8A"));
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(
                      height: 200,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: ButtonBottomWidget(
                  text: "العودة الى الرئيسية",
                  onPress: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const NewHomePage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
