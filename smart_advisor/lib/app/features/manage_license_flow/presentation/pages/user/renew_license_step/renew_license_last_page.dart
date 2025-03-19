import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/services/local/shared_prefs_manager.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/home_page/presentation/pages/new_home_page.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/bottom_buttons.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/license_card.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/renewal_terms_card.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/terms_with_steper.dart';
import 'package:smart_advisor/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/widgets/button_bottom.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

import '../../../../../../core/services/local/navigation_services.dart';

class RenewLicenseLastPage extends StatefulWidget {
  final ActivityDetailsPageParams args;
  final bool? isRejectRenew;

  const RenewLicenseLastPage(
      {super.key, required this.args, this.isRejectRenew = false});

  @override
  State<RenewLicenseLastPage> createState() => _RenewLicenseLastPageState();
}

class _RenewLicenseLastPageState extends State<RenewLicenseLastPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedPrefs.saveRecentlyOpened(widget.args);
  }

  @override
  Widget build(BuildContext context) {
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
                        // ------- 01 -------
                        widget.isRejectRenew!
                            ? RenewalTermsCard(
                                isWarning: true,
                                warningTital: "الذهاب الى المخالفات",
                                warningDescrition:
                                    "لا يمكنك تجديد هذه الرخصة لوجود غرامة مستحقة على الرخصة",
                                checkIconPath: IconPath.checkIcon,
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
                                    title:
                                        "لا ينبغي أن تقع الشركة في منطقة محظورة؛",
                                  ),
                                  TermModel(
                                    title:
                                        "يجب أن تقع الشركة في مبنى تجاري أو متعدد الاستخدامات؛",
                                  ),
                                  TermModel(
                                    title:
                                        "لا تفرض البلدية أي قيود على معالجة الطلبات من خلال بلدي؛",
                                  )
                                ],
                                hasIcon: false,
                              )
                            : Column(
                                children: [
                                  RenewalTermsCard(
                                    checkIconPath: IconPath.checkIcon,
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
                                        title:
                                            "لا ينبغي أن تقع الشركة في منطقة محظورة؛",
                                      ),
                                      TermModel(
                                        title:
                                            "يجب أن تقع الشركة في مبنى تجاري أو متعدد الاستخدامات؛",
                                      ),
                                      TermModel(
                                        title:
                                            "لا تفرض البلدية أي قيود على معالجة الطلبات من خلال بلدي؛",
                                      )
                                    ],
                                    hasIcon: false,
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // ------- 02 -------
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
                                  // ------- 03 -------
                                  TermsWithSteper(
                                    extraContainer: false,
                                    number: 3,
                                    title: "تجديد رخصتك التجارية ",
                                    description:
                                        "وفقًا للإجراءات المحددة، ستحتاج إلى اتباع الخطوات لإتمام الخدمة.",
                                    titleTerms:
                                        "تمر خطوة تجديد الرخصة بعدة مراحل:",
                                    steps: [
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
                                      ),
                                      StepData(
                                        title: 'اعتماد الدفاع المدني',
                                        icon: IconPath.purchased,
                                      ),
                                    ],
                                    renewTitleText: " ",
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
                                        color: const Color(0xff568F64)
                                            .withOpacity(0.04),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "حققت أول خطوتين؟  ابدأ بتجديد رخصتك التجارية الآن",
                                              textAlign: TextAlign.start,
                                              style: AppStyle.textRegularStyle
                                                  .copyWith(
                                                color:
                                                    AppColor.textPrimaryColor,
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
                                                  .add(SaveRenewDraft());
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "الذهاب الى الخدمة",
                                                      style: AppStyle
                                                          .footNoteRomanStyle
                                                          .copyWith(
                                                        color: AppColor.primary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SvgPicture.asset(
                                                    IconPath.stepArrowIcon)
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
                                  // ------- 04 -------
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.all(16),
                                    decoration: const BoxDecoration(
                                      color: AppColor.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned(
                                          right: -20,
                                          top: -35,
                                          child: Container(
                                            height: 41,
                                            width: 41,
                                            margin: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: AppColor.backgroundColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(25)),
                                            ),
                                            child: FittedBox(
                                              child: Container(
                                                height: 31,
                                                width: 31,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColor.textPrimaryColor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(25)),
                                                ),
                                                child: Text(
                                                  "04",
                                                  textAlign: TextAlign.center,
                                                  style: AppStyle
                                                      .footNoteBoldStyle
                                                      .copyWith(
                                                          color: AppColor
                                                              .surfacePrimaryColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 24,
                                              left: 16,
                                              right: 23),
                                          width: double.infinity,
                                          child: Column(children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "واصل ممارسة عملك!",
                                                  style: AppStyle.somarSemiBold
                                                      .copyWith(
                                                          color: AppColor
                                                              .statusAttentionColor,
                                                          fontSize: 16),
                                                ),
                                                SvgPicture.asset(
                                                    IconPath.doingWorkIcon)
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                                "لقد وصلت الى هدفك! الآن انت تملك رخصة تجارية وتمارس عملك التجاري .",
                                                style: AppStyle.textRegularStyle
                                                    .copyWith(
                                                        color: AppColor
                                                            .textSecondaryColor,
                                                        fontSize: 14,
                                                        height: 1.7)),
                                            Text(
                                                " إحرص على التزامك بالاشتراطات البلدية الخاصة بنشاطك حتى تحافظ على سريان عملك وتوسعته بنجاح.",
                                                style: AppStyle.textRegularStyle
                                                    .copyWith(
                                                        color: AppColor
                                                            .textSecondaryColor,
                                                        fontSize: 14,
                                                        height: 1.7)),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    RouteName.regulationPage,
                                                    arguments: context
                                                        .read<
                                                            ManageMainFlowBloc>()
                                                        .args);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(14),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: const Color(
                                                              0xff568F64)
                                                          .withOpacity(0.21)),
                                                  color: const Color(0xff568F64)
                                                      .withOpacity(0.04),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8)),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "عرض الإشتراطات الخاصة بنشاطك",
                                                              style: AppStyle
                                                                  .footNoteRomanStyle
                                                                  .copyWith(
                                                                color: AppColor
                                                                    .primary,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SvgPicture.asset(
                                                            IconPath
                                                                .stepArrowIcon)
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  // ------- 05 -------
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.all(16),
                                    decoration: const BoxDecoration(
                                      color: AppColor.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned(
                                          right: -20,
                                          top: -35,
                                          child: Container(
                                            height: 41,
                                            width: 41,
                                            margin: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: AppColor.backgroundColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(25)),
                                            ),
                                            child: FittedBox(
                                              child: Container(
                                                height: 31,
                                                width: 31,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColor.textPrimaryColor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(25)),
                                                ),
                                                child: Text(
                                                  "05",
                                                  textAlign: TextAlign.center,
                                                  style: AppStyle
                                                      .footNoteBoldStyle
                                                      .copyWith(
                                                          color: AppColor
                                                              .surfacePrimaryColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 24,
                                              left: 16,
                                              right: 23),
                                          width: double.infinity,
                                          child: Column(children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "الإلتزام والإمتثال",
                                                  style: AppStyle.somarSemiBold
                                                      .copyWith(
                                                          color: AppColor
                                                              .textPrimaryColor,
                                                          fontSize: 16),
                                                ),
                                                SvgPicture.asset(
                                                    IconPath.complianceIcon)
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                                "ستتلقى زيارات دورية من مراقبي البلدية للتحقق من التزام عملك بالإشتراطات. تعاونك خلال الزيارة سيسهم في تطوير مدينتك وبناء بيئة مزدهرة.",
                                                style: AppStyle.textRegularStyle
                                                    .copyWith(
                                                        color: AppColor
                                                            .textSecondaryColor,
                                                        fontSize: 14,
                                                        height: 1.7)),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    RouteName.violationPage,
                                                    arguments: context
                                                        .read<
                                                            ManageMainFlowBloc>()
                                                        .args);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(14),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: const Color(
                                                              0xff568F64)
                                                          .withOpacity(0.21)),
                                                  color: const Color(0x00068f64)
                                                      .withOpacity(0.04),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "عرض قوائم التفحص",
                                                      style: AppStyle
                                                          .footNoteRomanStyle
                                                          .copyWith(
                                                        color: AppColor.primary,
                                                      ),
                                                    ),
                                                    SvgPicture.asset(
                                                        IconPath.stepArrowIcon)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                NavigationService
                                                    .navigatorKey.currentState!
                                                    .pushNamed(
                                                        RouteName
                                                            .ratingItemsPage,
                                                        arguments:
                                                            ActivityDetailsPageParams(
                                                          licenseNo: state
                                                              .selectedLicense
                                                              ?.licenseNo,
                                                          workFlow: [],
                                                          isFromHome: false,
                                                          activityId: context
                                                              .read<
                                                                  ManageMainFlowBloc>()
                                                              .args
                                                              ?.activityId,
                                                        ));
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(14),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: const Color(
                                                              0xff568F64)
                                                          .withOpacity(0.21)),
                                                  color: const Color(0x00068f64)
                                                      .withOpacity(0.04),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "تقييم درجة امتثال منشأتك",
                                                      style: AppStyle
                                                          .footNoteRomanStyle
                                                          .copyWith(
                                                        color: AppColor.primary,
                                                      ),
                                                    ),
                                                    SvgPicture.asset(
                                                        IconPath.stepArrowIcon)
                                                  ],
                                                ),
                                              ),
                                            )
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                        const SizedBox(
                          height: 230,
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
