import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/features/home_page/presentation/pages/new_home_page.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/bottom_buttons.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/license_card.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/renewal_terms_card.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/terms_with_steper.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/widgets/button_bottom.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../blocs/main_flow_bloc/main_flow_bloc.dart';

class TransfarOwnerLicenseUserPage extends StatefulWidget {
  final bool? isTransfar;
  const TransfarOwnerLicenseUserPage({super.key, this.isTransfar = false});

  @override
  State<TransfarOwnerLicenseUserPage> createState() =>
      _TransfarOwnerLicenseUserPageState();
}

class _TransfarOwnerLicenseUserPageState
    extends State<TransfarOwnerLicenseUserPage> {
  @override
  Widget build(BuildContext context) {
    bool? isWarning = false;
    return BlocBuilder<ManageMainFlowBloc, ManageMainFlowState>(
      builder: (context, state) {
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
                        LicenseCard(
                          expiryDate:
                              state.selectedLicense?.licenseEndDate ?? "",
                          stateLicense:
                              state.selectedLicense?.licenseStatusName ?? "",
                          copiedText:
                              state.selectedLicense?.licenseNo.toString() ?? "",
                          ownerName: state.selectedLicense?.shopName ?? "",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RenewalTermsCard(
                          isWarning: widget.isTransfar,
                          warningTital: "الذهاب الى الطلبات",
                          warningDescrition:
                              "لا يمكنك نقل ملكية هذه الرخصة لوجود طلب على الرخصة معلق",
                          checkIconPath: IconPath.checkIcon,
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
                              title:
                                  "عدم وجود اعتراضات مسجلة على الرخصة المحددة.",
                            ),
                            TermModel(
                              title:
                                  "يجب أن تكون الأنشطة الإضافية متوافقة مع النشاط الأساسي.",
                            ),
                            TermModel(
                              title:
                                  "يجب ألا يكون النشاط التجاري في منطقة محظورة.",
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
                              //     isCalculator: true,
                            ),
                          ],
                          extraContainer: false,
                          renewTitleText: "",
                          renewDescriptionText: "",
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TermsWithSteper(
                          extraContainer: false,
                          number: 3,
                          title: "إجراءات المالك الجديد للرخصة",
                          description:
                              "وفقًا للإجراءات المحددة، ستحتاج إلى اتباع الخطوات لإتمام الخدمة.",
                          titleTerms: "تمر خطوة نقل الملكية بعدة مراحل:",
                          steps: [
                            StepData(
                              title: 'استلام رسالة نصية تحتوي على طلب النقل',
                              icon: IconPath.note,
                            ),
                            StepData(
                              title:
                                  'مراجعة بيانات الرخصة وتعديل الخصائص الضرورية',
                              icon: IconPath.editing,
                            ),
                            StepData(
                              title:
                                  'تجهيز صك الملكية أو عقد الاستثمار أو عقد الإيجار',
                              icon: IconPath.editing,
                            ),
                            StepData(
                              title:
                                  'مراجعة كافة التفاصيل للتأكد من صحة المعلومات',
                              icon: IconPath.editing,
                            ),
                            StepData(
                              title:
                                  'الموافقة النهائية من كلا الطرفين لإتمام النقل.',
                              icon: IconPath.note_blank,
                            )
                          ],
                          renewTitleText: "",
                          renewDescriptionText: "",
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 20),
                          decoration: const BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16)),
                          ),
                          child: Container(
                            height: 110,
                            padding: const EdgeInsets.only(
                              top: 14,
                              right: 16,
                              left: 26,
                            ),
                            margin: EdgeInsets.only(
                                left: 24, right: 60, bottom: 30),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xff568F64)
                                      .withOpacity(0.21)),
                              color: const Color(0xff568F64).withOpacity(0.04),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("هل أنت مستعد لنقل ملكية رخصتك؟",
                                    textAlign: TextAlign.start,
                                    style: AppStyle.textRegularStyle.copyWith(
                                      color: AppColor.textPrimaryColor,
                                      fontSize: 14,
                                      height: 1.6,
                                    )),
                                const SizedBox(
                                  height: 12,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context
                                        .read<ManageMainFlowBloc>()
                                        .transfer();
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "الذهاب الى الخدمة",
                                            style: AppStyle.footNoteRomanStyle
                                                .copyWith(
                                              color: AppColor.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SvgPicture.asset(IconPath.stepArrowIcon)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                    child: CustomBottomButtons(
                      nextText: "العودة الى الرئيسية",
                      prevText: "العودة الى الرئيسية",
                      isNextOnly: true,
                      isNextDisabled: false,
                      onNext: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const NewHomePage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      onPrev: () {},
                    ),
                  ),
                  if (state.status == BlocStatus.loading)
                    Center(
                      child: CircularProgressIndicator(
                        color: AppColor.statusAccentColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
