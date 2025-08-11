import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/features/home_page/presentation/pages/new_home_page.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/renewal_terms_card.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/terms_with_steper.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/widgets/button_bottom.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:url_launcher/url_launcher.dart';

class EditLicensePage extends StatelessWidget {
  const EditLicensePage({super.key});

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
                        "رحلتك لتعديل رخصتك",
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
                      title: "ما يمكنك تعديله على رخصتك",
                      description:
                          "تعرّف على الخيارات المتاحة لتعديل بيانات رخصتك بسهولة عبر المنصة:",
                      listOfTerms: [
                        TermModel(
                          title: "الأنشطة التجارية",
                          description:
                              "إضافة أو إزالة الأنشطة وتغيير النشاط الأساسي.",
                        ),
                        TermModel(
                          title: "التصاريح",
                          description:
                              "إصدار تصاريح جديدة لتفعيل خيارات معينة، مثل خدمة التوصيل للمنازل.",
                        ),
                        TermModel(
                          title: "مساحات الموقع",
                          description:
                              "تعديل المساحات المرتبطة بالأنشطة الحالية أو الأنشطة الجديدة.",
                        ),
                      ],
                      hasIcon: false,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TermsWithSteper(
                      number: 2,
                      title: "تعديل رخصتك التجارية ",
                      description:
                          "وفقًا للإجراءات المحددة، ستحتاج إلى اتباع الخطوات لإتمام الخدمة.",
                      titleTerms: "تمر خطوة تعديل الرخصة بعدة مراحل:",
                      steps: [
                        StepData(
                          title: 'تسجيل الدخول إلى "بلدي"',
                          icon: IconPath.note,
                        ),
                        StepData(
                          title: 'تحديد الرخصة للتعديل',
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
                      ],
                      renewTitleText: "هل أنت مستعد لتعديل رخصتك؟",
                      renewDescriptionText: "الذهاب الى خدمة تعديل رخصة تجارية",
                      onPress: () {
                        launchUrl(Uri.parse(
                            "https://balady.gov.sa/ar/services/%D8%AA%D8%B9%D8%AF%D9%8A%D9%84-%D8%B1%D8%AE%D8%B5%D8%A9-%D9%86%D8%B4%D8%A7%D8%B7-%D8%AA%D8%AC%D8%A7%D8%B1%D9%8A"));
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
