import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/features/home_page/presentation/pages/new_home_page.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/renewal_terms_card.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/terms_with_steper.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/widgets/button_bottom.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:url_launcher/url_launcher.dart';

class RenweLicensePage extends StatelessWidget {
  const RenweLicensePage({super.key});

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
                        "رحلتك لتجديد رخصتك",
                        style: AppStyle.somarSemiBold.copyWith(
                            color: AppColor.textPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RenewalTermsCard(
                      number: 1,
                      title: "تحقق من الشروط والأحكام للتجديد",
                      description:
                          "تحقق من الشروط والأحكام التالية للتأكد من استيفاء متطلبات التجديد:",
                      listOfTerms: [
                        TermModel(
                          title:
                              "يجب أن يكون الترخيص صالحًا ويظل صالحًا لمدة 3 أشهر أو أقل؛",
                        ),
                        TermModel(
                          title:
                              "لا ينبغي أن تكون هناك رسوم أو غرامات مستحقة واجبة الدفع؛",
                        ),
                        TermModel(
                          title: "لا ينبغي أن تقع الشركة في منطقة محظورة؛",
                        ),
                        TermModel(
                          title:
                              "يجب أن تقع الشركة في مبنى تجاري أو متعدد الاستخدامات؛",
                        ),
                        TermModel(
                          title:
                              "لا تفرض البلدية أي قيود على معالجة الطلبات من خلال بلدي؛",
                        ),
                      ],
                      hasIcon: false,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    RenewalTermsCard(
                      number: 2,
                      title: "إعداد الوثائق",
                      description:
                          "قم بإعداد الوثائق المطلوبة لضمان استيفاء متطلبات تجديد الرخصة:",
                      listOfTerms: [
                        TermModel(
                          title:
                              "عقد إدارة النفايات (إذا لم تكن الشركة في مركز تسوق/ منطقة تغطيها الأمانة)",
                        ),
                        TermModel(
                            title:
                                "عقد ملكية / عقد إيجار / عقد استثمار العقار"),
                        TermModel(
                          title: "إثبات ملكية العلامة التجارية",
                        ),
                        TermModel(
                          title: "صورة اللافتات",
                        ),
                        TermModel(
                          title: "رخصة البناء",
                        ),
                      ],
                      hasIcon: false,
                      iconPath: IconPath.doubleCard,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TermsWithSteper(
                      number: 3,
                      title: "تجديد رخصتك التجارية ",
                      description:
                          "وفقًا للإجراءات المحددة، ستحتاج إلى اتباع الخطوات لإتمام الخدمة.",
                      titleTerms: "تمر خطوة تجديد الرخصة بعدة مراحل:",
                      steps: [
                        StepData(
                          title: 'تسجيل الدخول إلى "بلدي"',
                          icon: IconPath.note,
                        ),
                        StepData(
                          title: 'تحديد الرخصة للتجديد',
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
                          //   isCalculator: true,
                        ),
                        StepData(
                          title: 'اعتماد الدفاع المدني',
                          icon: IconPath.checkbox,
                        ),
                      ],
                      renewTitleText: "هل أنت مستعد لتجديد رخصتك؟",
                      renewDescriptionText: "الذهاب الى خدمة تجديد رخصة تجارية",
                      onPress: () {
                        launchUrl(Uri.parse(
                            "https://balady.gov.sa/ar/services/%D8%AA%D8%AC%D8%AF%D9%8A%D8%AF-%D8%B1%D8%AE%D8%B5%D8%A9-%D8%AA%D8%AC%D8%A7%D8%B1%D9%8A%D8%A9"));
                      },
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
