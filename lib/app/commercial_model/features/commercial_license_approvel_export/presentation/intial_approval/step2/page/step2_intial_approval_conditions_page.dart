import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/under_testing/custom_enhanced_expansion_panel_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/constants.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';

import '../../../../../../../features/_shared_feature_/balady_features/widgets/shared/circle_icon.dart';
import '../../../../../commercial_license/domain/entities/sub_activity_details_entity.dart';


class Step2IntialApprovalConditionsPage extends StatefulWidget {
  final List<ActivityTerm>? activityTerms;

  const Step2IntialApprovalConditionsPage({super.key, this.activityTerms});

  @override
  State<Step2IntialApprovalConditionsPage> createState() => _Step2IntialApprovalConditionsPageState();
}

class _Step2IntialApprovalConditionsPageState extends State<Step2IntialApprovalConditionsPage> {
  bool isAgree = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        color: AppColor.scaffoldBackground,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DrawLineWidget(
              lineWidth: 70.0,
              lineHeight: 6.0,
              lineColor: AppColor.blackModern200Light,
              radius: 46.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: CustomTextWidget(
                    "",
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    textStyle: AppStyle.mainTextSecondaryStyle.copyWith(
                      fontSize: 24.0,
                      color: AppColor.black,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: CircleIcon(
                    icon: Icons.close,
                    iconColor: AppColor.primary600Light,
                    backgroundColor: AppColor.geyser.withOpacity(0.4),
                    iconSize: 18,
                  ),
                ),
              ],
            ),
            ...[
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView.builder(
                          itemCount: widget.activityTerms?.length ?? 0,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 8),
                              child: ExpansionSectionItem(
                                term: widget.activityTerms![index],
                              ),
                            );
                          }),
                      FormPledgesSummuryWidget(
                          title: "cr_consent_conditions_title".tr(),
                          consent: "cr_consent_conditions_desc".tr(),
                          consentcheck: "cr_consent_conditions_check".tr(),
                          currentValue: isAgree,
                          onChanged: (val) {
                            setState(() {
                              isAgree = val;
                            });
                          }),
                      const CustomVerticalSpace(height: 16),
                      ElevatedButtonWidget.custom(
                          text: "cr_consent_conditions_agree".tr(),
                          isDisabled: !isAgree,
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  ),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}

class ConditionItem extends StatelessWidget {
  final String? name;
  final List<String>? values;
  const ConditionItem({super.key, this.name, this.values});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: Color(0x80E6EFEF),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (name != null && name!.isNotEmpty)
            CustomTextWidget(
              name!,
              fontColor: AppColor.primary700Light,
              fontSize: 12,
              fontWeight: AppFontWeight.bold,
            ),
          if (name != null && name!.isNotEmpty)
            const CustomVerticalSpace(height: 4),
          if ((values?.length ?? 0) <= 1)
            Html(
              data: values?.firstOrNull ?? "",
              style: {
                "body": Style(
                    fontSize: FontSize(14.0),
                    fontWeight: FontWeight.bold,
                    color: AppColor.blackModern700Light,
                    // lineHeight: const LineHeight(2),
                    fontFamily: Constants.appFontType),
              },
              onLinkTap: (url, attributes, element) {
                CommonFunctions.openBaladyWebView(url);
              },
            ),
          if ((values?.length ?? 0) > 1)
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: values?.length ?? 0,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(IconPath.checked),
                          const CustomHorizontalSpace(width: 4),
                          Flexible(
                            child: Html(
                              data: values?[index] ?? "",
                              style: {
                                "body": Style(
                                    fontSize: FontSize(14.0),
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.blackModern700Light,
                                    //   lineHeight: const LineHeight(2),
                                    fontFamily: Constants.appFontType),
                              },
                              onLinkTap: (url, attributes, element) {
                                CommonFunctions.openBaladyWebView(url);
                              },
                            ),
                          ),
                        ],
                      ),
                      const CustomVerticalSpace(height: 8)
                    ],
                  );
                }),
        ],
      ),
    );
  }
}

class ExpansionSectionItem extends StatelessWidget {
  final ActivityTerm term;

  const ExpansionSectionItem({super.key, required this.term});

  @override
  Widget build(BuildContext context) {
    return CustomExpansionPanelWidget(
      title: term.sectionName,
      leading: SvgPicture.asset(IconPath.serviceCardDesc),
      children: term.sectionContent?.map((e) {
            return ConditionItem(name: e.label, values: e.value ?? []);
          }).toList() ??
          [],
    );
  }
}
