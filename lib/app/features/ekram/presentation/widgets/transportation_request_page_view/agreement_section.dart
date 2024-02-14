import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_check_box_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';

class AgreementSection extends StatelessWidget {
  const AgreementSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                // controller: _scrollController,
                child: Container(
                  margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VdHeaderDesc(
                        header: ("review_request").tr(),
                      ),
                      const ApplicationInfo(),
                      const CustomVerticalSpace(
                        height: 16,
                      ),
                      const DeceasedInfo(),
                      const CustomVerticalSpace(
                        height: 16,
                      ),
                      const PledgesSummuryWidget()
                    ],
                  ),
                ),
              ),
            ),
            EkramPreviousNextButtons()
          ],
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VdHeaderDesc(
                        header: Helpers.translatingWord("ekramAgreement"),
                      ),
                      CustomCheckBoxTopStartWidget(
                          onSelected: (value) {
                            context
                                .read<EkramRequestTransportationBloc>()
                                .add(ChangeAgreementEvent(isagree: value));
                          },
                          backgroundColor: Colors.white,
                          checkboxValue: state.agreement ?? false,
                          containerBackgroundColor: Colors.transparent,
                          borderSelectedColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          checkBoxAlignment: AlignmentDirectional.topStart,
                          titleSize: 14,
                          checkboxSize: 1,
                          verticalPadding: 5,
                          title: ("agreement_text").tr().replaceAll(
                              "{}", CommonProperties.userInfo?.arName ?? ""))
                    ],
                  ),
                ),
              ),
            ),
            EkramPreviousNextButtons()
          ],
        );
      },
    );
  }
}

class ApplicationInfo extends StatelessWidget {
  const ApplicationInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(builder: (context, state) {
      return ExpandableCard(
        title: Helpers.translatingWord("ekram_main_data"),
        icon: IconPath.vdSummuryUserInfo,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: Helpers.translatingWord("ekramFullName"),
                subTitle: state.fullName,
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: Helpers.translatingWord("ekramMobile"),
                subTitle: state.mobileNumber,
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: Helpers.translatingWord("ekramRelationShip"),
                subTitle: state.relation,
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: Helpers.translatingWord("burialCity"),
                subTitle: state.selectedCity?.name,
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: Helpers.translatingWord("transportation_status"),
                subTitle:
                    Helpers.translatingWord("transportation_from_hospital"),
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: Helpers.translatingWord("ekramHospital"),
                subTitle:
                    state.selectedHospital?.name ?? state.otherHospitalName,
              ),
            ],
          )
        ],
      );
    });
  }
}

class DeceasedInfo extends StatelessWidget {
  const DeceasedInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(builder: (context, state) {
      return ExpandableCard(
        title: Helpers.translatingWord("ekram_dead_deads_info"),
        icon: IconPath.vdSummurySPL,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomVerticalSpace(
                height: 16,
              ),
              ListView.builder(
                itemCount: state.deceasedInfoDto?.length ?? 0,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return DeceasedCardWidget(
                    deceasedItem: state.deceasedInfoDto![index],
                    showDelete: false,
                    onDelete: () async {},
                    onEdit: () async {},
                  );
                },
              )
            ],
          )
        ],
      );
    });
  }
}

class PledgesSummuryWidget extends StatelessWidget {
  const PledgesSummuryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("vd_pledges").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryPledge),
          isExpanded: true,
          children: [
            CustomTextWidget(
              ("agreement_text").tr().replaceAll(
                  "{}", CommonProperties.userInfo?.getFullName() ?? ""),
              fontColor: AppColor.blackModern700Light,
              maxLines: 90,
              height: 1.3,
              textAlign: TextAlign.start,
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
                      value: state.agreement ?? false,
                      activeColor: AppColor.primary900Light,
                      onChanged: (newVal) {
                        context
                            .read<EkramRequestTransportationBloc>()
                            .add(ChangeAgreementEvent(isagree: newVal));
                      },
                    ),
                    Flexible(
                      child: CustomTextWidget(
                        ("vd_consent_check").tr(),
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
        );
      },
    );
  }
}
