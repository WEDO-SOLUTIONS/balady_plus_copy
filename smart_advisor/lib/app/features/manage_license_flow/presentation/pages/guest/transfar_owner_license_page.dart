import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/features/home_page/presentation/pages/new_home_page.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/renewal_terms_card.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/terms_with_steper.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/widgets/button_bottom.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:url_launcher/url_launcher.dart';

class TransfarOwnerLicensePage extends StatelessWidget {
  const TransfarOwnerLicensePage({super.key});

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
                        "رحلتك لنقل ملكية رخصتك",
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
                      title: "التحقق من شروط وأحكام نقل الملكية",
                      description:
                          "تحقق من الشروط والأحكام التالية للتأكد من استيفاء متطلبات النقل:",
                      listOfTerms: [
                        TermModel(
                          title: "يجب أن تكون الرخصة سارية أو منتهية.",
                        ),
                        TermModel(
                          title:
                              "عدم وجود طلبات قيد الإجراء على الرخصة المحددة.",
                        ),
                        TermModel(
                          title: "عدم وجود اعتراضات مسجلة على الرخصة المحددة.",
                        ),
                        TermModel(
                          title:
                              "يجب أن تكون الأنشطة الإضافية متوافقة مع النشاط الأساسي.",
                        ),
                        TermModel(
                          title: "يجب ألا يكون النشاط التجاري في منطقة محظورة.",
                        ),
                        TermModel(
                          title:
                              "يجب أن يكون المالك الحالي والجديد مسجلين في منصة بلدي.",
                        ),
                        TermModel(
                          title:
                              "يجب أن يكون السجل التجاري للمالك الجديد نشطًا.",
                        ),
                      ],
                      hasIcon: false,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TermsWithSteper(
                      number: 2,
                      title: "إجراءاتك كمالك الرخصة الحالي",
                      description:
                          "وفقًا للإجراءات المحددة، ستحتاج إلى اتباع الخطوات لإتمام الخدمة.",
                      titleTerms: "تمر خطوة نقل الملكية بعدة مراحل:",
                      steps: [
                        StepData(
                          title: 'تسجيل الدخول إلى "بلدي"',
                          icon: IconPath.note,
                        ),
                        StepData(
                          title: 'تحديد الرخصة لنقل الملكية',
                          icon: IconPath.editing,
                        ),
                        StepData(
                          title: 'مراجعة الرخصة وتحديد التصاريح للنقل',
                          icon: IconPath.editing,
                        ),
                        StepData(
                          title: 'ادخال السجل التجاري للمالك الجديد',
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
                      renewTitleText: "هل أنت مستعد لنقل ملكية رخصتك؟",
                      renewDescriptionText: "الذهاب الى الخدمة",
                      onPress: () {
                        launchUrl(Uri.parse(
                            "https://balady.gov.sa/ar/services/%D9%86%D9%82%D9%84-%D9%85%D9%84%D9%83%D9%8A%D8%A9-%D8%B1%D8%AE%D8%B5%D8%A9-%D8%AA%D8%AC%D8%A7%D8%B1%D9%8A%D8%A9"));
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TermsWithSteper(
                      number: 3,
                      title: "إجراءاتك كمالك الرخصة المستقبلي",
                      description:
                          "وفقًا للإجراءات المحددة، ستحتاج إلى اتباع الخطوات لإتمام الخدمة.",
                      titleTerms: "تمر خطوة نقل الملكية بعدة مراحل:",
                      steps: [
                        StepData(
                          title: 'استلام رسالة نصية تحتوي على طلب النقل',
                          icon: IconPath.note,
                        ),
                        StepData(
                          title: 'مراجعة بيانات الرخصة وتعديل الخصائص الضرورية',
                          icon: IconPath.editing,
                        ),
                        StepData(
                          title:
                              'تجهيز صك الملكية أو عقد الاستثمار أو عقد الإيجار',
                          icon: IconPath.editing,
                        ),
                        StepData(
                          title: 'مراجعة كافة التفاصيل للتأكد من صحة المعلومات',
                          icon: IconPath.editing,
                        ),
                        StepData(
                          title:
                              'الموافقة النهائية من كلا الطرفين لإتمام النقل.',
                          icon: IconPath.note_blank,
                        ),
                        StepData(
                          title: ' إصدار الفاتورة',
                          icon: IconPath.purchased,
                        ),
                      ],
                      renewTitleText: "هل أنت مستعد لقبول نقل الملكية؟",
                      renewDescriptionText: "الذهاب الى الخدمة",
                      onPress: () {
                        launchUrl(Uri.parse(
                            "https://balady.gov.sa/ar/services/%D9%82%D8%A8%D9%88%D9%84-%D9%86%D9%82%D9%84-%D9%85%D9%84%D9%83%D9%8A%D8%A9-%D8%B1%D8%AE%D8%B5%D8%A9-%D8%AA%D8%AC%D8%A7%D8%B1%D9%8A%D8%A9"));
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
