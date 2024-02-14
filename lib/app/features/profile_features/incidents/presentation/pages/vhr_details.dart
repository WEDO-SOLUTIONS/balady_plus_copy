import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../home_page/presentation/widgets/home_tag.dart';
import '../../../../objectable_transactions/presentation/widgets/summery_widgets/field_data.dart';
import '../../domain/entities/request_details_page_params.dart';
import '../details_bloc/crm_details_bloc.dart';
import '../widgets/replies_status_card.dart';
import '../widgets/request_status_card.dart';
import '../widgets/status_tag.dart';

class VHRDetailsPage extends StatefulWidget {
  const VHRDetailsPage({super.key});

  @override
  State<VHRDetailsPage> createState() => _VHRDetailsPageState();
}

class _VHRDetailsPageState extends State<VHRDetailsPage> {
  @override
  Widget build(BuildContext context) {
    RequestDetailsPageParams params =
        ModalRoute.of(context)!.settings.arguments as RequestDetailsPageParams;

    return BlocProvider(
      create: (context) =>
          CrmDetailsBloc(crmRequestType: RequestsType.VHR, pageParams: params),
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
                title: ("order_details").tr(),
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
                              StatusTag(
                                  name: state.pageParams?.details.getStatus() ??
                                      "",
                                  onTap: () async {
                                    await BottomSheetDialog.showDraggableSheet(
                                        context,
                                        dialogKeyName:
                                            DialogName.vhrDetailsStatusDialog,
                                        currentRouteName: RouteName.VHRDetails,
                                        isFullHeight: false,
                                        height: 300,
                                        child: RepliesStatusCard(
                                          auditInformation: [
                                            state
                                                    .requestDetails
                                                    ?.incidentInformation
                                                    ?.deptManagerNotes ??
                                                ""
                                          ],
                                          visibleFlag: state
                                              .requestDetails
                                              ?.incidentInformation
                                              ?.visibleFlag,
                                          status: state.pageParams?.details
                                              .getStatus(),
                                          bloc: context.read<CrmDetailsBloc>(),
                                          pzInsKey: state.pageParams?.details
                                                  ?.pzInsKey ??
                                              "",
                                        ));
                                  }),
                            ],
                          ),
                          const CustomVerticalSpace(height: 16),
                          CustomExpansionPanelWidget(
                            title: ("dc_vc_details").tr(),
                            leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                            children: [
                              FieldData(
                                title: ("dc_vc_type").tr(),
                                subTitle: state.requestDetails
                                        ?.vehicleInformation?.vehicleType ??
                                    "",
                              ),
                              CustomVerticalSpace(height: 8),
                              FieldData(
                                title: ("dc_vc_model").tr(),
                                subTitle: state.requestDetails
                                        ?.vehicleInformation?.vehicleModel ??
                                    "",
                              ),
                              CustomVerticalSpace(height: 8),
                              FieldData(
                                title: ("dc_vc_plateNumber").tr(),
                                subTitle: state
                                        .requestDetails
                                        ?.vehicleInformation
                                        ?.vehiclePlateNumber ??
                                    "",
                              ),
                              CustomVerticalSpace(height: 8),
                              FieldData(
                                title: ("dc_vc_chassie").tr(),
                                subTitle: state.requestDetails
                                        ?.vehicleInformation?.chassisNumber ??
                                    "",
                              ),
                            ],
                          ),
                          CustomVerticalSpace(height: 16),
                          CustomExpansionPanelWidget(
                              title: ("lbl_attachments").tr(),
                              leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                              children: []),
                        ],
                      ))),
                  if (state.crmRequestsStatus ==
                      BlocRequestStatus.submissionGetLoading)
                    CustomCircularLoadingWidget(),
                  if (state.crmRequestsStatus ==
                      BlocRequestStatus.submissionGetFailure)
                    ReloadWidget(
                      onTab: () {
                        context.read<CrmDetailsBloc>().loadData();
                      },
                    )
                ],
              ));
        },
      ),
    );
  }
}
