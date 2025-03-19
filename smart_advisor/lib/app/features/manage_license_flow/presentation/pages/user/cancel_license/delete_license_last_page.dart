import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/features/home_page/presentation/pages/new_home_page.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/bottom_buttons.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/button_bottom.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/license_card.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/renewal_terms_card.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/terms_with_steper.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

import '../../../../../../core/utils/enums/bloc_status.dart';

class DeleteLicenseLastPage extends StatelessWidget {
  const DeleteLicenseLastPage({super.key, this.isCanceled = false});
  final bool? isCanceled;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageMainFlowBloc, ManageMainFlowState>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SafeArea(
              child: Stack(children: [
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
                      LicenseCard(
                        expiryDate: state.selectedLicense?.licenseEndDate ?? "",
                        stateLicense:
                            state.selectedLicense?.licenseStatusName ?? "",
                        copiedText:
                            state.selectedLicense?.licenseNo.toString() ?? "",
                        ownerName: state.selectedLicense?.shopName ?? "",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      isCanceled!
                          ? const RenewalTermsCard(
                              isWarning: true,
                              warningTital: "الذهاب الى المخالفات",
                              warningDescrition:
                                  "تأكد من دفعك لجميع الغرامات المعلقة على رخصتك",
                              number: 1,
                              title: "لا يمكنك الغاء هذه الرخصة",
                              description: "يوجد غرامات مستحقة على هذه الرخصة",
                              listOfTerms: [],
                              iconPath: IconPath.warning,
                              hasIcon: false,
                              isBasicColor: false,
                            )
                          : Column(
                              children: [
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
                                  extraContainer: false,
                                  number: 2,
                                  title: "الغاء رخصتك التجارية ",
                                  description:
                                      "وفقًا للإجراءات المحددة، ستحتاج إلى اتباع الخطوات لإتمام الخدمة.",
                                  titleTerms:
                                      "تمر خطوة الغاء الرخصة بعدة مراحل:",
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
                                      //  isCalculator: true,
                                    ),
                                  ],
                                  renewTitleText: " ",
                                  renewDescriptionText: "",
                                ),
                              ],
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
                          margin:
                              EdgeInsets.only(left: 24, right: 60, bottom: 30),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    const Color(0xff568F64).withOpacity(0.21)),
                            color: const Color(0xff568F64).withOpacity(0.04),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("هل أنت مستعد لإلغاء رخصتك؟",
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
                                      .add(SaveCencelDraft());
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "الذهاب الى خدمة إلغاء رخصة تجارية",
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
              ]),
            ),
          ),
        );
      },
    );
  }
}
