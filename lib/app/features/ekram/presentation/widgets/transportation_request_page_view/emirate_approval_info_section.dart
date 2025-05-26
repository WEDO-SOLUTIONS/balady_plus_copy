import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/constants.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EmirateApprovalInfoSection extends StatelessWidget {
  const EmirateApprovalInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<EkramRequestTransportationBloc>();
    bloc.add(GetMadinahEmirateApprovalStatusEvent(
        cemetryId: bloc.state.requestDetailsModel?.cemeteryData?.cemeteryId,
        id: bloc.state.deceasedId,
        idType: bloc.state.selectedNationalIdType?.id));
    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(IconPath.editIcon),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'ekram_emirate_approval_info'.tr(),
                                  style: const TextStyle(
                                    color: AppColor.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            state.valid ?? false
                                ? Column(
                                    children: [
                                      CustomTextFieldWidget(
                                        label:
                                            "ekram_baquie_approval_date".tr(),
                                        initialValue:
                                            state.madinahEmirateApprovalDate ??
                                                '',
                                        disabledColor: AppColor.grey900Light,
                                        readOnly: true,
                                      ),
                                      CustomTextFieldWidget(
                                          label: "ekram_baquie_approval_status"
                                              .tr(),
                                          initialValue: state
                                                  .madinahEmirateApprovalStatus ??
                                              '',
                                          readOnly: true,
                                          disabledColor: AppColor.grey900Light,
                                          suffixIcon: SvgPicture.asset(
                                            IconPath.calendar,
                                            width: 30,
                                            height: 30,
                                          ),
                                          onChanged: (String? text) {},
                                          onValidate: (String? value) {
                                            return null;
                                          }),
                                    ],
                                  )
                                : Html(
                                    data: state.errorMessage!,
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
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            EkramPreviousNextButtons(
              btnPressed: () {
                if (state.validateEmirateApprovalInfoSection()) {
                  context
                      .read<EkramRequestTransportationBloc>()
                      .add(const GoToNextPageEvent());
                }
              },
            )
          ],
        );
      },
    );
  }
}
