import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/constants/remote_config.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../_shared_feature_/presentation/widgets/notes_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../objections/domain/entities/objection_details.dart';
import '../../domain/entities/transaction_details_params.dart';

import '../objections_details_bloc/objection_details_bloc.dart';
import '../widgets/create_objection_page/objection_attachment_item.dart';
import '../widgets/objection_feedback_widget.dart';

class ObjectionsDetailsPage extends StatefulWidget {
  const ObjectionsDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ObjectionsDetailsPage> createState() => _ObjectionsDetailsPageState();
}

class _ObjectionsDetailsPageState extends State<ObjectionsDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.openObjectionsDetails);
  }

  @override
  Widget build(BuildContext context) {
    Map? data = ModalRoute.of(context)!.settings.arguments as Map?;

    return BlocProvider(
      create: (context) => ObjectionsDetailsBloc()
        ..add(
          GetObjectionDetailsEvent(
            params: data?['objectionRequestNumber'] ?? '',
          ),
        ),
      child: BlocConsumer<ObjectionsDetailsBloc, ObjectionDetailsState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: AppColor.white2,
                appBar: DetailsHeader(
                  title: ("objection_details").tr(),
                  procedures: state.details?.requestStatusId == "004"
                      ? () async {
                          await BottomSheetDialog.showDraggableSheet(context,
                              isFullHeight: false,
                              height: 250,
                              //   dialogKeyName: DialogName.appointmentsActionsDialog,
                              //   currentRouteName: RouteName.appointmentDetailsRoute,
                              child: BottomSheetWithActions(
                                title: "actions".tr(),
                                body: Column(children: [
                                  GestureDetector(
                                    onTap: () {
                                      BottomSheetDialog.showDraggableSheet(
                                        NavigationService
                                            .navigatorKey.currentContext!,
                                        child: BottomSheetWithActions(
                                            title: "",
                                            action: Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButtonWidget
                                                      .primaryCustom(
                                                          text: "agree".tr(),
                                                          onPressed: () {
                                                            NavigationService
                                                                .goBack();
                                                            NavigationService
                                                                .goBack();
                                                            context
                                                                .read<
                                                                    ObjectionsDetailsBloc>()
                                                                .add(
                                                                    CancelObjectionEvent());
                                                          }),
                                                ),
                                                const CustomHorizontalSpace(
                                                    width: 32),
                                                Expanded(
                                                  child: ElevatedButtonWidget
                                                      .primaryCustomBorder( 
                                                          text: "cancelButton"
                                                              .tr(),
                                                          onPressed: () {
                                                            NavigationService
                                                                .goBack();
                                                          }),
                                                ),
                                              ],
                                            ),
                                            body: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const CustomVerticalSpace(
                                                    height: 32),
                                                NotesWidget(notes: [
                                                  "cancel_objection_desc".tr()
                                                ])
                                              ],
                                            )),
                                      );
                                    },
                                    child: FieldData(
                                      title: "cancel_objection_title".tr(),
                                    ),
                                  ),
                                  CustomVerticalSpace(height: 16),
                                ]),
                              ));
                        }
                      : null,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      // body

                      Constants.verticalSpaceSmall,
                      // TransferInfo
                      ObjectionsDetails(
                        onShowViolation: () {
                          context
                              .read<ObjectionsDetailsBloc>()
                              .add(const OpenObjectableDetails());
                        },
                        //relation: widget.params.rel,
                      ),
                      Constants.verticalSpaceSmall,

                      const SubmitterDetails(),
                      Constants.verticalSpaceSmall,

                      const CommiteDetails(),
                      Constants.verticalSpaceSmall,

                      const ObjectionReaason(),
                      Constants.verticalSpaceSmall,

                      const ObjectionFeedBack(),
                      Constants.verticalSpaceSmall,
                    ]),
                  ),
                ),
              ),
              if (state.status == BlocStatus.loading)
                const CustomCircularLoadingWidget(),
            ],
          );
        },
      ),
    );
  }
}

class ObjectionsDetails extends StatelessWidget {
  final Function onShowViolation;

  const ObjectionsDetails({Key? key, required this.onShowViolation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectionsDetailsBloc, ObjectionDetailsState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
            title: ("objection_details_data").tr(),
            leading: SvgPicture.asset(IconPath.vdSummuryDesc),
            children: [
              FieldData(
                title: ("objection_details_number").tr(),
                subTitle: state.details?.objectionRequestNumber,
              ),
              const CustomVerticalSpace(height: 8),
              FieldData(
                title: ("objection_details_type").tr(),
                subTitle: state.details?.objectionTypeName,
              ),
              const CustomVerticalSpace(height: 8),
              FieldData(
                  title: ("objection_details_request_transaction").tr(),
                  subTitle: state.details?.requestSubmitterData
                          ?.objectedTransactionDisplayNumber ??
                      ""),
              const CustomVerticalSpace(height: 8),
              GestureDetector(
                onTap: () {
                  onShowViolation();
                },
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    FieldData(
                      title: ("display_transaction_number").tr(),
                    ),
                    IconButton(
                        onPressed: () {},
                        color: AppColor.primary900Light,
                        icon: Icon(Icons.arrow_right_outlined))
                  ],
                ),
              ),
              const CustomVerticalSpace(height: 8),
              FieldData(
                title: ("objection_details_service").tr(),
                subTitle: state.details?.serviceName,
              ),
              const CustomVerticalSpace(height: 8),
              FieldData(
                title: ("objection_details_request_type").tr(),
                subTitle: state.details?.objectionServiceName,
              ),
              const CustomVerticalSpace(height: 8),
              FieldData(
                title: ("objection_details_request_data").tr(),
                subTitle: state.details?.getRequestSubmitDate ?? "",
              ),
              const CustomVerticalSpace(height: 8),
              FieldData(
                title: ("objection_details_request_update").tr(),
                subTitle: state.details?.getLastUpdatedDate,
              ),
              const CustomVerticalSpace(height: 8),
              FieldData(
                title: ("objection_details_request_status").tr(),
                subTitle: state.details?.requestStatusName,
              ),
            ]);
      },
    );
  }
}

class SubmitterDetails extends StatelessWidget {
  const SubmitterDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectionsDetailsBloc, ObjectionDetailsState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
            underline: false,
            leading: SvgPicture.asset(IconPath.vdSummuryUserInfo),
            title: ("objection_details_submitter_data").tr(),
            children: [
              FieldData(
                title: ("objection_details_submitter_id").tr(),
                subTitle: state.details?.requestSubmitterData?.id,
              ),
              CustomVerticalSpace(height: 8),
              FieldData(
                title: ("objection_details_submitter_name").tr(),
                subTitle: state.details?.requestSubmitterData?.fullName,
              ),
            ]);
      },
    );
  }
}

class CommiteDetails extends StatelessWidget {
  const CommiteDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectionsDetailsBloc, ObjectionDetailsState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
            underline: false,
            leading: SvgPicture.asset(IconPath.vdSummuryDesc),
            title: ("objection_details_commite").tr(),
            children: [
              FieldData(
                title: ("objection_details_commite_desc").tr(),
                subTitle: state.details?.committeeDecision?.decision,
              ),
              SizedBox(
                height: 8,
              ),
              if (state.details?.committeeDecision?.decisionPdf
                      ?.contentLocation !=
                  null)
                ObjectionAttachmentItem(
                    width: double.infinity,
                    name: "objection_download_commite_decision".tr(),
                    file: ReasonAttachment(
                        contentLocation: state.details?.committeeDecision
                                ?.decisionPdf?.contentLocation ??
                            "",
                        fileName: state.details?.committeeDecision?.decisionPdf
                                ?.fileName ??
                            ""))
            ]);
      },
    );
  }
}

class ObjectionReaason extends StatelessWidget {
  const ObjectionReaason({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectionsDetailsBloc, ObjectionDetailsState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          underline: false,
          title: ("objection_details_objections_list").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
          children: [
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.details?.objectionReasonsList?.length ?? 0,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FieldData(
                          title: " ${"reason_text".tr()} ${index + 1}",
                          subTitle: state.details?.objectionReasonsList?[index]
                                  .reason ??
                              "",
                          radius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                        ),


                        FieldData(
                          title: "attachment_text".tr(),
                          radius: BorderRadius.zero,
                        ),
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: state
                                    .details
                                    ?.objectionReasonsList![index]
                                    .reasonAttachment
                                    ?.length ??
                                0,
                            itemBuilder: (ctx, i) {
                              if( state
                                  .details!
                                  .objectionReasonsList![index]
                                  .reasonAttachment![i].contentLocation != null) {
                                return ObjectionAttachmentItem(
                                  file: state
                                      .details!
                                      .objectionReasonsList![index]
                                      .reasonAttachment![i], sessionId:state
                                      .details!.sessionID ,);
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                        CustomVerticalSpace(height: 8)
                      ],
                    );
                  }),
            )
          ],
        );
      },
    );
  }
}

class AttachmentWidget extends StatelessWidget {
  final String attachment;

  const AttachmentWidget({Key? key, required this.attachment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 296,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                //MM
                //   NavigationService.navigatorKey.currentState!.pushNamed(
                //       RoutesNames.dmsImageFullScreen,
                //      arguments: attachment);
              },
              child: SizedBox(
                width: 265,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomNetworkImageWidget(
                      attachment,
                      imageHeight: 265,
                      imageWidth: 265,
                      ssoAuth: true,
                    ),
                  ],
                ),
              ),
            ),
            CustomHorizontalSpace(width: 12),
          ],
        ));
  }
}

class ObjectionFeedBack extends StatefulWidget {
  const ObjectionFeedBack({Key? key}) : super(key: key);

  @override
  State<ObjectionFeedBack> createState() => _ObjectionFeedBackState();
}

class _ObjectionFeedBackState extends State<ObjectionFeedBack> {
  int expandedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectionsDetailsBloc, ObjectionDetailsState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          underline: false,
          title: ("objection_enquiry_requests").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
          children: [
            ((state.details?.enquiryList?.isNotEmpty ?? false))
                ? MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.details?.enquiryList?.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          return ObjectionFeedBackWidget(
                            index: index,
                            item: state.details!.enquiryList![index],
                            isExpanded: index == expandedIndex,
                            onExpand: () {
                              setState(() {
                                expandedIndex = index;
                              });
                            },
                            onRefresh: () {
                              context
                                  .read<ObjectionsDetailsBloc>()
                                  .add(GetObjectionDetailsEvent(
                                    params:
                                        state.details?.objectionRequestNumber ??
                                            "",
                                  ));
                            },
                          );
                        }),
                  )
                : CustomTextWidget(
                    "objection_enquiry_none".tr(),
                    fontColor: AppColor.blackModern500Light,
                  )
          ],
        );
      },
    );
  }
}
