import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/features/home_page/presentation/pages/new_home_page.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/user/edit_license_step/renewal_terms_card.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/bottom_buttons.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/license_card.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/renewal_terms_card.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/terms_with_steper.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

import '../../../../../../core/utils/enums/bloc_status.dart';

class EditLicenseLastPage extends StatelessWidget {
  final bool? isAddOrCancel;
  final bool? isAdd;
  const EditLicenseLastPage(
      {super.key, this.isAddOrCancel = false, this.isAdd = false});

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
                          extraContainer: false,
                          number: 2,
                          title: "تعديل رخصتك التجارية ",
                          description:
                              "وفقًا للإجراءات المحددة، ستحتاج إلى اتباع الخطوات لإتمام الخدمة.",
                          titleTerms: "تمر خطوة تعديل الرخصة بعدة مراحل:",
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
                              //   isCalculator: true,
                            ),
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
                                Text("هل أنت مستعد لتعديل رخصتك؟",
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
                                        .modifyLicenseDraft();
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "الذهاب الى خدمة تعديل رخصة تجارية",
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
