import 'package:balady_plus/app/core/utils/app_analytics_events.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../transaction_inquiry/data/general_inquiry_data.dart';
import '../../../transaction_inquiry/presentation/core/view_models/inquiry/inquiry_view_model.dart';

class QAAskMore extends StatelessWidget {
  const QAAskMore({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(children: [
        Row(
          children: [
            SvgPicture.asset(
              IconPath.archiveBook,
            ),
            CustomHorizontalSpace(width: 4),
            CustomTextWidget(
              "qa_ask_more".tr(),
              fontSize: 18,
              fontWeight: AppFontWeight.bold,
              fontColor: AppColor.blackModern600Light,
            ),
          ],
        ),
        CustomVerticalSpace(height: 16),
        SvgPicture.asset(
          IconPath.note2,
        ),
        CustomVerticalSpace(height: 16),
        CustomTextWidget(
          "qa_ask_more_desc".tr(),
          fontSize: 14,
          fontWeight: AppFontWeight.bold,
          fontColor: AppColor.blackModern600Light,
        ),
        CustomVerticalSpace(height: 32),
        ElevatedButtonWidget.primaryCustomBorder(
            onPressed: () async {
              CustomerVoiceReportTypeModel type = CustomerVoiceReportTypeModel(
                  code: "INQC-016",
                  icon: IconPath.Inq_3Icon,
                  key: "",
                  title: "Inq_3",
                  id: 15);

              if (CommonProperties.isLoggedInMunicipality) {
                bool isSuccess = await locator<InquiryViewModel>()
                    .getAllSplClassifications(type);

                //MM
                if (isSuccess) {
                  CommonFunctions.sendEventToAnalytics(
                      AppEvents.askBuildingCompliance);

                  NavigationService.navigatorKey.currentState!
                      .pushNamed(RouteName.generalInquiryPage, arguments: type);
                }
              } else {
                showDialog(
                    context: context,
                    builder: (ctx) => NeedLoginDialog(
                            onSuccessLogin: (bool? isSuccess) async {
                          if (isSuccess ?? false) {
                            bool isSuccess = await locator<InquiryViewModel>()
                                .getAllSplClassifications(type);

                            //MM
                            if (isSuccess) {
                              CommonFunctions.sendEventToAnalytics(
                                  AppEvents.askBuildingCompliance);

                              NavigationService.navigatorKey.currentState!
                                  .pushNamed(RouteName.generalInquiryPage,
                                      arguments: type);
                            }
                          }
                        }));
              }
            },
            text: "qa_send_question".tr())
      ]),
    );
  }
}
