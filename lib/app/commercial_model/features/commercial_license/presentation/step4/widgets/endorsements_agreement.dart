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
import '../../../../../../features/_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../../../../features/home_page/home_exports.dart';
import '../../../domain/entities/sub_activity_details_entity.dart';

class EndorsementsAgreement extends StatefulWidget {
  final List<String>? lstEndorsements;

  const EndorsementsAgreement({super.key, this.lstEndorsements});

  @override
  State<EndorsementsAgreement> createState() => _EndorsementsAgreementState();
}

class _EndorsementsAgreementState extends State<EndorsementsAgreement> {
  bool isAgree = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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

            ...[
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      CustomExpansionPanelWidget(
                        title: "cr_consent_conditions_title".tr(),
                        leading: SvgPicture.asset(IconPath.vdSummuryPledge),
                        isExpanded: true,
                        children: [

                          Html(
                            data:widget.lstEndorsements![0],
                            onLinkTap: (url, attributes, element) {
                              CommonFunctions.openBaladyWebView(url);
                            },
                            style: {
                              "body": Style(
                                  fontSize: FontSize(12.0),
                                  fontWeight: FontWeight.w600,
                                  lineHeight: const LineHeight(1.3),
                                  textAlign: TextAlign.start,
                                  color: AppColor.blackModern700Light,
                                  fontFamily: Constants.appFontType),
                            },
                          ),
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
                                        isAgree = newVal!;
                                      });
                                    },
                                  ),
                                  Flexible(
                                    child: CustomTextWidget(
                                      "cr_consent_conditions_check".tr(),
                                      fontColor: AppColor.primary700Light,
                                      fontSize: 12,
                                      maxLines: 10,
                                      fontWeight: AppFontWeight.semiBold,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
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

