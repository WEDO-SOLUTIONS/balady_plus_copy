import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../home_page/presentation/widgets/home_tag.dart';
import '../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../bloc/compliance_bloc.dart';
import '../bloc/compliance_event.dart';
import '../bloc/compliance_state.dart';
import '../dialogs/confirm_cancel_license_dialog.dart';
import '../widgets/summery_widgets/location_summury_widget.dart';
import '../widgets/summery_widgets/step1_summury_widget.dart';
import '../widgets/summery_widgets/step2_2_summury_widget.dart';
import '../widgets/summery_widgets/step2_summury_widget.dart';
import '../widgets/summery_widgets/step3_summury_widget.dart';
import '../widgets/summery_widgets/step4_summury_widget.dart';
import '../widgets/summery_widgets/step5_summury_widget.dart';
import '../widgets/summery_widgets/step6_1_summury_widget.dart';
import '../widgets/summery_widgets/step6_summury_widget.dart';
import '../widgets/summery_widgets/step7_summury_widget.dart';
import 'complete_compliance_page.dart';

class ComplianceDetailsPage extends StatefulWidget {
  const ComplianceDetailsPage({super.key});

  @override
  State<ComplianceDetailsPage> createState() => _ComplianceDetailsPageState();
}

class _ComplianceDetailsPageState extends State<ComplianceDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(
      UXCamEvents.My_Requests_Compliance_Details_Request_Event,
    );
  }

  @override
  Widget build(BuildContext context) {



    final data = ModalRoute.of(context)!.settings.arguments as Map;


    return BlocProvider(
      create: (context) => ComplianceBloc(showDetails: true)
        ..add(
          GetRequestDetails(
            requestId: data['requestNumber'],
            redirectUrl: data['redirectUrl'],
          ),
        ),
      child: BlocListener<ComplianceBloc, ComplianceState>(
        listener: (context, state) {},
        child: BlocBuilder<ComplianceBloc, ComplianceState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColor.white2,
              appBar: DetailsHeader(
                title: "order_details".tr(),
                onPrint: state.requestDetails?.statusId == 5
                    ? () => context
                        .read<ComplianceBloc>()
                        .add(DownloadCertificateEvent())
                    : null,
                procedures: (state.requestDetails?.statusId == 1 ||
                        state.requestDetails?.statusId == 28)
                    ? () async {
                        await BottomSheetDialog.showDraggableSheet(context,
                            isFullHeight: false,
                            height: 250,
                            //MM
                            dialogKeyName:
                                DialogName.complianceRequestActionsDialog,
                            currentRouteName: RouteName.complianceDetailsPage,
                            child: BottomSheetWithActions(
                              title: "actions".tr(),
                              body: Column(children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (state
                                            .requestDetails?.submitterThrough ==
                                        "BENEFICARY") {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (ctx) {
                                        return CompleteCompliancePage(
                                          bloc: BlocProvider.of(context),
                                        );
                                      }));
                                    } else {
                                      CommonFunctions
                                          .openBaldyWithRefreshCookie(
                                        data['redirectUrl'],
                                      );
                                    }
                                  },
                                  child: FieldData(
                                    title: Helpers.translatingWord('edit'),
                                  ),
                                ),
                                CustomVerticalSpace(height: 16),
                                GestureDetector(
                                  onTap: () async {
                                    await BottomSheetDialog.showDraggableSheet(
                                        context,
                                        isFullHeight: false,
                                        dialogKeyName: DialogName
                                            .complianceRequestActionsDeleteDialog,
                                        currentRouteName:
                                            RouteName.complianceDetailsPage,
                                        child: ConfirmCancelLicenseDialog(
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        context.read<ComplianceBloc>().add(
                                            DeleteComplianceRequestEvent());
                                      },
                                    ));
                                  },
                                  child: FieldData(
                                    title: Helpers.translatingWord('cancel'),
                                  ),
                                ),
                              ]),
                            ));
                      }
                    : null,
              ),
              body: Stack(
                children: [
                  if (state.detailsStatus ==
                      BlocRequestStatus.submissionGetSuccess)
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
                                      state.requestDetails?.creationDate ?? "",
                                      fontColor: AppColor.blackModern500Light,
                                      fontSize: 12,
                                      fontWeight: AppFontWeight.bold,
                                    )
                                  ],
                                ),
                                HomeTag(
                                  title: state.requestDetails?.statusName ?? "",
                                  backgroundColor: AppColor.secondary100Light,
                                )
                              ],
                            ),
                            const CustomVerticalSpace(height: 16),
                            Step1SummeryWidget(),
                            CustomVerticalSpace(height: 16),
                            Step2SummeryWidget(),
                            CustomVerticalSpace(height: 16),
                            Step2_2SummeryWidget(),
                            CustomVerticalSpace(height: 16),
                            Step3SummeryWidget(),
                            CustomVerticalSpace(height: 16),
                            LocationSummuryWidget(),
                            Step4SummeryWidget(),
                            CustomVerticalSpace(height: 16),
                            // if (state.requestDetails?.submitterThrough ==
                            //     "BENEFICARY" || state.requestDetails?.submitterThrough ==
                            //     "MOMTATHEL" )
                              Step5SummeryWidget(),
                            CustomVerticalSpace(height: 16),
                            Step6SummeryWidget(),
                            CustomVerticalSpace(height: 16),
                            Step6_1SummeryWidget(),
                            CustomVerticalSpace(height: 16),
                            Step7SummeryWidget(),
                            CustomVerticalSpace(height: 16),
                          ],
                        ))),
                  if (state.detailsStatus ==
                          BlocRequestStatus.submissionGetLoading ||
                      state.status == BlocStatus.loading)
                    CustomCircularLoadingWidget(),
                  if (state.detailsStatus == BlocRequestStatus.failure)
                    ReloadWidget(
                      onTab: () {
                        context.read<ComplianceBloc>().add(
                              GetRequestDetails(
                                requestId: data['requestNumber'],
                                redirectUrl: data['redirectUrl'],
                              ),
                            );
                      },
                    ),
                  /* if (state.requestDetails?.statusId == 1)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16, bottom: 32),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButtonWidget.primaryCustom(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) {
                              return CompleteCompliancePage(
                                bloc: BlocProvider.of(context),
                              );
                            }));
                          },
                          text: "إكمال الطلب",
                        ),
                      ),
                    )*/
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
