//import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

import '../../../../../../core/services/local/navigation_services.dart';
import '../../../../../shared_features/widgets/webview_page.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/general_html_dialog.dart';
import '/app/features/details/presentation/bloc/details_bloc.dart';
import '/app/features/details/presentation/bloc/details_state.dart';
import '/app/features/fees_calculator/presentation/pages/calculator_page.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

import '/app/core/utils/constants/language.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/Requirements_fines_View.dart';
// import 'package:url_launcher/link.dart';
// import 'package:url_launcher/url_launcher.dart';

class DetailsUserGuide extends StatelessWidget {
  const DetailsUserGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      buildWhen: (previous, current) =>
          previous.entityActivityDetailsStatus !=
          current.entityActivityDetailsStatus,
      builder: (context, state) {
        return Column(
          children: [
            Column(
              children: [
                Container(
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('target_audince'.tr(),
                            style: AppStyle.textRegularRomanStyle.copyWith(
                                color: AppColor.textPrimaryColor,
                                fontSize: 14)),
                        Text(
                            state.entityActivityDetailsResponse?.guide
                                    ?.firstOrNull?.fieldTargetCategories ??
                                "",
                            style: AppStyle.footNoteRomanStyle
                                .copyWith(color: AppColor.textTertiaryColor))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("apply_channels".tr(),
                            style: AppStyle.textRegularRomanStyle.copyWith(
                                color: AppColor.textPrimaryColor,
                                fontSize: 14)),
                        Wrap(
                          children: state.entityActivityDetailsResponse?.guide
                                  ?.firstOrNull?.fieldServiceChanelsExport
                                  ?.map(
                                    (e) => SvgPicture.asset(
                                      color: AppColor.statusAccentColor,
                                      e.id == 10110
                                          ? IconPath.mobileEmpty
                                          : IconPath.monitorIcon,
                                    ),
                                  )
                                  .toList() ??
                              [],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // const SizedBox(width: 8,),
                        Text("payment_methods".tr(),
                            style: AppStyle.textRegularRomanStyle.copyWith(
                                color: AppColor.textPrimaryColor,
                                fontSize: 14)),
                        Image.asset(
                          'packages/smart_advisor/smart_advisor_assets/images/payment.png',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // const SizedBox(width: 8,),
                        Text("cost".tr(),
                            style: AppStyle.textRegularRomanStyle.copyWith(
                                color: AppColor.textPrimaryColor,
                                fontSize: 14)),
                        InkWell(
                          onTap: () {
                            NavigationService.navigatorKey.currentState!
                                .push(MaterialPageRoute(builder: (ctx) {
                              return FeesCalculatorPage(
                                args: context.read<DetailsBloc>().args,
                              );
                            }));
                          },
                          child: Text(("fee_calculator").tr(),
                              style: AppStyle.footNoteRomanStyle
                                  .copyWith(color: AppColor.statusAccentColor)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return WebViewPage(
                        url: state.entityActivityDetailsResponse?.guide
                                ?.firstOrNull?.fieldUserGuide ??
                            "",
                        title: "details".tr(),
                      );
                    }));
                  },
                  child: Container(
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("user_guide".tr(),
                              style: AppStyle.textRegularRomanStyle.copyWith(
                                  color: AppColor.textPrimaryColor,
                                  fontSize: 14)),
                          SvgPicture.asset(IconPath.download)
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    showModalBottomSheet(
                      backgroundColor: const Color(0xff000000),
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) => GeneralHtmlDialog(
                        title: "apply_methods".tr(),
                        html: state.entityActivityDetailsResponse?.guide
                                ?.firstOrNull?.fieldHowToApply ??
                            "",
                      ),
                    );
                  },
                  child: Container(
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("apply_methods".tr(),
                              style: AppStyle.textRegularRomanStyle.copyWith(
                                  color: AppColor.textPrimaryColor,
                                  fontSize: 14)),
                          SvgPicture.asset(IconPath.arrowR)
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    showModalBottomSheet(
                      backgroundColor: const Color(0xff000000),
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) => GeneralHtmlDialog(
                        title: "requirements_1".tr(),
                        html: state.entityActivityDetailsResponse?.guide
                                ?.firstOrNull?.fieldRequirements ??
                            "",
                      ),
                    );
                  },
                  child: Container(
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('requirements_1'.tr(),
                              style: AppStyle.textRegularRomanStyle.copyWith(
                                  color: AppColor.textPrimaryColor,
                                  fontSize: 14)),
                          SvgPicture.asset(IconPath.arrowR)
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    showModalBottomSheet(
                      backgroundColor: const Color(0xff000000),
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) => RequirementsFinesView(
                          url: state.entityActivityDetailsResponse?.guide
                                  ?.firstOrNull?.fieldServiceRequirements ??
                              ""),
                    );
                  },
                  child: Container(
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("fines_and_conditions".tr(),
                              style: AppStyle.textRegularRomanStyle.copyWith(
                                  color: AppColor.textPrimaryColor,
                                  fontSize: 14)),
                          SvgPicture.asset(IconPath.arrowR)
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    /*  showModalBottomSheet(
                      backgroundColor: Color(0xff000000),
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) =>
                          const RequirementsFinesView(),
                    );*/

                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return WebViewPage(
                        url: state.entityActivityDetailsResponse
                                ?.securityCamRegulations ??
                            "",
                        title: "details".tr(),
                      );
                    }));
                  },
                  child: Container(
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('الشروط الفنية لانظمة وزارة الداخلية ',
                              style: AppStyle.textRegularRomanStyle.copyWith(
                                  color: AppColor.textPrimaryColor,
                                  fontSize: 14)),
                          SvgPicture.asset(IconPath.arrowR)
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                  btnColor: AppColor.statusAccentColor,
                  textColor: AppColor.white,
                  onPress: () {
                    //  BaladyServices.openIssueLicense();
                  },
                  text: ("apply_commercial_license").tr(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
