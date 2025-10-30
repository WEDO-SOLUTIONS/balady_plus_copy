import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/base/base_view.dart';
import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_check_box_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../core/services/view_models/new_terms_health_license_view_model.dart';
import '../../widgets/new_health_certificate_widgets/previous_next_buttons.dart';

class PledgesStepScreen extends StatefulWidget {
  const PledgesStepScreen({Key? key}) : super(key: key);

  @override
  _PledgesStepScreenState createState() => _PledgesStepScreenState();
}

class _PledgesStepScreenState extends State<PledgesStepScreen> {
  bool isAgree = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //MM  Helpers.sendEventToAnalytics(AppEvents.HealthCertificate_Apply_Pledges);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<NewTermsHealthLicenseViewModel>(
        onModelReady: (model) {},
        builder: (context, model, child) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              children: [
                /* Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const CustomVerticalSpace(height: 22),
                          CustomTextWidget(
                            Helpers.translatingWord('pledges'),
                            fontSize: 17,
                            fontColor: AppColor.black,
                            textAlign: TextAlign.start,
                          ),
                          Constants.verticalSpaceSmall,
                          CustomTextWidget(
                              Helpers.translatingWord('check_location_info'),
                              fontColor: AppColor.black400,
                              fontWeight: AppFontWeight.medium,
                              fontSize: 13,
                              textAlign: TextAlign.start),
                          const CustomVerticalSpace(height: 34),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: model.getTerms().length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, index) {
                                return agreeText(model.getTerms()[index]);
                              })
                        ]),
                  ),
                ),*/

                Expanded(
                  child: CustomExpansionPanelWidget(
                    title: ("vd_pledges").tr(),
                    isExpanded: true,
                    underline: false,
                    leading: SvgPicture.asset(IconPath.vdSummuryPledge),
                    children: [
                      /*CustomTextWidget(
                              ("consent_body").tr(),
                              fontColor: AppColor.blackModern700Light,
                              maxLines: 90,
                              height: 1.3,
                              textAlign: TextAlign.start,
                            ),*/

                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: model.getTerms().length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return agreeText(model.getTerms()[index]);
                          }),
                      CustomVerticalSpace(height: 8),
                      Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Color(0x80E6EFEF),
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Checkbox(
                                value: isAgree,
                                activeColor: AppColor.primary900Light,
                                onChanged: (newVal) {
                                  setState(() {
                                    isAgree = newVal ?? false;
                                  });
                                },
                              ),
                              Flexible(
                                child: CustomTextWidget(
                                  ("vd_consent_check").tr(),
                                  fontColor: AppColor.primary700Light,
                                  fontSize: 12,
                                  maxLines: 10,
                                  fontWeight: AppFontWeight.semiBold,
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
                PreviousNextButtons(
                  isFormValid: isAgree,
                  onConfirm: () {
                    model.hideKeyboard();
                    model.submit().then((value) {});
                  },
                )
              ],
            ),
          );
        });
  }
}

class agreeText extends StatelessWidget {
  final String text;

  const agreeText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 6,
                height: 4,
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    color: AppColor.greenishYellow500)),
            const CustomHorizontalSpace(width: 6),
            Flexible(
              child: CustomTextWidget(text,
                  fontColor: AppColor.black600,
                  fontWeight: AppFontWeight.medium,
                  fontSize: 13,
                  height: 1.5,
                  maxLines: 100,
                  textAlign: TextAlign.start),
            ),
          ],
        ),
        Constants.verticalSpaceMedium
      ],
    );
  }
}

class agreeAndButton extends StatefulWidget {
  @override
  State<agreeAndButton> createState() => _agreeAndButtonState();
}

class _agreeAndButtonState extends State<agreeAndButton> {
  bool isButtonDisabled = true;
  final model = locator<NewTermsHealthLicenseViewModel>();
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: AppColor.white,
        child: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomCheckBoxWidget(
                  onSelected: (checked) {
                    setState(() {
                      isButtonDisabled = !checked!;
                    });
                  },
                  checkboxValue: false,
                  title: "agree_all_the_above".tr(),
                  containerBackgroundColor: AppColor.white3,
                ),
                EnhancedCustomElevatedButtonWidget(
                  btnColor: isButtonDisabled
                      ? AppColor.black200
                      : AppColor.primary900Light,
                  btnTextColor:
                      isButtonDisabled ? AppColor.black400 : AppColor.white,
                  btnPressed: isButtonDisabled
                      ? null
                      : () {
                          model.submit().then((value) {});
                        },
                  btnText: Helpers.translatingWord("submit_order"),
                  btnTextSize: 16,
                  btnTextWeight: AppFontWeight.regular,
                  btnHeight: 56,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
