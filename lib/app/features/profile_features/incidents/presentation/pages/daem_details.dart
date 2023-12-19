import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../home_page/presentation/widgets/home_tag.dart';
import '../../../../objectable_transactions/presentation/widgets/summery_widgets/field_data.dart';
import '../../domain/entities/request_details_page_params.dart';
import '../details_bloc/crm_details_bloc.dart';
import '../widgets/attachment_list_widget.dart';
import '../widgets/status_tag.dart';

class DaemDetailsPage extends StatefulWidget {
  const DaemDetailsPage({super.key});

  @override
  State<DaemDetailsPage> createState() => _DaemDetailsPageState();
}

class _DaemDetailsPageState extends State<DaemDetailsPage> {
  @override
  Widget build(BuildContext context) {
    RequestDetailsPageParams params =
        ModalRoute.of(context)!.settings.arguments as RequestDetailsPageParams;

    return BlocProvider(
      create: (context) =>
          CrmDetailsBloc(crmRequestType: RequestsType.TSR, pageParams: params),
      child: BlocConsumer<CrmDetailsBloc, CrmDetailsState>(
        listener: (context, state) {
          if (state.crmRequestsStatus ==
              BlocRequestStatus.submissionGetFailure) {
            CommonFunctions.showError(state.error ?? "");
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColor.white2,
            appBar: DetailsHeader(
              title: "order_details".tr(),
              onPrint: null,
            ),
            body: Stack(
              children: [
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  IconPath.calendarIcon,
                                  width: 24,
                                  height: 24,
                                ),
                                CustomHorizontalSpace(width: 8),
                                CustomTextWidget(
                                  state.pageParams?.details.getCreateDate() ??
                                      "",
                                  fontColor: AppColor.blackModern500Light,
                                  fontSize: 12,
                                  fontWeight: AppFontWeight.bold,
                                )
                              ],
                            ),
                            HomeTag(
                              title: state.pageParams?.details.getStatusSTR() ??
                                  "",
                              backgroundColor: AppColor.secondary100Light,
                            )
                          ],
                        ),
                        const CustomVerticalSpace(height: 16),
                        CustomExpansionPanelWidget(
                            title: ("order_summery").tr(),
                            leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                            children: [
                              FieldData(
                                title: ("request_no").tr(),
                                subTitle: state.pageParams?.details.getId(),
                              ),
                              CustomVerticalSpace(height: 8),
                              FieldData(
                                title: ("daem_municiplaity").tr(),
                                subTitle:
                                    state.details?.daemInformation?.locationAR,
                              ),
                              CustomVerticalSpace(height: 8),
                              FieldData(
                                title: ("daem_sub_municiplaity").tr(),
                                subTitle:
                                    state.details?.daemInformation?.baladiahAR,
                              ),
                              CustomVerticalSpace(height: 8),
                              FieldData(
                                title: ("ticket_type").tr(),
                                subTitle:
                                    state.details?.daemInformation?.categoryAR,
                              ),
                              CustomVerticalSpace(height: 8),
                              FieldData(
                                title: ("daem_main_classification").tr(),
                                subTitle:
                                    state.details?.daemInformation?.subCategory,
                              ),
                              CustomVerticalSpace(height: 8),
                              FieldData(
                                title: ("daem_sub_classification").tr(),
                                subTitle: state.details?.daemInformation?.area,
                              ),
                              CustomVerticalSpace(height: 8),
                              FieldData(
                                title: ("daem_spl_classification").tr(),
                                subTitle:
                                    state.details?.daemInformation?.issueType,
                              ),
                              CustomVerticalSpace(height: 8),
                              FieldData(
                                title: ("daem_ticket_desc").tr(),
                                subTitle: state.details?.daemInformation
                                    ?.incidentDescription,
                              ),
                              CustomVerticalSpace(height: 8),
                              if (state.details?.daemInformation
                                      ?.getLastUserComment()
                                      .isNotEmpty ??
                                  false)
                                FieldData(
                                  title: ("daem_ticket_user_comment").tr(),
                                  subTitle: state.details?.daemInformation
                                      ?.getLastUserComment(),
                                ),
                            ]),
                        CustomVerticalSpace(height: 16),
                        if (state.details?.incidentInformation?.questionList !=
                            null)
                          CustomExpansionPanelWidget(
                              title: ("inc_addetional_fields").tr(),
                              leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: state
                                            .details
                                            ?.incidentInformation
                                            ?.questionList
                                            ?.length ??
                                        0,
                                    itemBuilder: (ctx, index) => FieldData(
                                          title: state
                                                  .details
                                                  ?.incidentInformation
                                                  ?.questionList?[index]
                                                  .fieldName ??
                                              "",
                                          subTitle: state
                                                  .details
                                                  ?.incidentInformation
                                                  ?.questionList?[index]
                                                  .getSelectedFieldValue() ??
                                              "",
                                        ))
                              ]),
                        CustomVerticalSpace(height: 16),
                        CustomExpansionPanelWidget(
                            title: ("lbl_attachments").tr(),
                            leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                            children: [
                              AttachmentViewSection(
                                incidentNumber:
                                    state.pageParams?.details.incidentNumber,
                              )
                            ]),
                      ],
                    ))),
                if (state.crmRequestsStatus ==
                    BlocRequestStatus.submissionGetLoading)
                  CustomCircularLoadingWidget()
              ],
            ),
          );
        },
      ),
    );
  }
}
