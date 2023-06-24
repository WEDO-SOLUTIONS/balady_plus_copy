import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../objections/domain/entities/objection_details.dart';
import '../../domain/entities/transaction_details_params.dart';

import '../objections_details_bloc/objection_details_bloc.dart';
import '../widgets/create_objection_page/objection_attachment_item.dart';

class ObjectionsDetailsPage extends StatefulWidget {
  final ObjectionDetails? params;

  const ObjectionsDetailsPage({Key? key, required this.params})
      : super(key: key);

  @override
  State<ObjectionsDetailsPage> createState() => _ObjectionsDetailsPageState();
}

class _ObjectionsDetailsPageState extends State<ObjectionsDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ObjectionsDetailsBloc(
          getObjectionDetails: sl(), getTransactionDetails: sl()),
      child: BlocBuilder<ObjectionsDetailsBloc, ObjectionDetailsState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColor.white2,
            body: Stack(
              children: [
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // header
                    const DetailsHeader(
                      title: ("objection_details"),
                    ),
                    // body
                    SliverList(
                      delegate: SliverChildListDelegate.fixed(
                        [
                          Constants.verticalSpaceSmall,
                          // TransferInfo
                          ObjectionsDetails(
                            onShowViolation: () {
                              context
                                  .read<ObjectionsDetailsBloc>()
                                  .add(GetTransactionDetailsEvent(
                                      params: TransactionDetailsParams(
                                    applicationId:
                                        state.details?.serviceGroupId ?? "13",
                                    id: state.details?.requestSubmitterData
                                            ?.objectedTransactionId ??
                                        "",
                                  )));
                            },
                            //relation: widget.params.rel,
                          ),
                          const SubmitterDetails(),

                          const CommiteDetails(),

                          const ObjectionReaason(),
                          //CemetryInfo(name: widget.params.cemeteryName),

                          Constants.verticalSpaceSmall,
                        ],
                      ),
                    )
                  ],
                ),
                if (state.status == BlocStatus.loading)
                  CustomCircularLoadingWidget(),
              ],
            ),
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
            children: [
              FieldData(
                title: ("objection_details_number").tr(),
                subTitle: state.details?.objectionRequestNumber,
              ),
              FieldData(
                title: ("objection_details_type").tr(),
                subTitle: state.details?.objectionTypeName,
              ),
              GestureDetector(
                onTap: () {
                  onShowViolation();
                },
                child: CustomExpansionPanelWidget(
                  title: ("objection_details_request_transaction").tr(),
                  children: [
                    CustomHorizontalSpace(width: 16),
                    CustomTextWidget(
                      state.details?.requestSubmitterData
                              ?.objectedTransactionId ??
                          "",
                      fontColor: AppColor.black400,
                      fontSize: 13.0,
                      textAlign: TextAlign.start,
                      height: 1.3,
                    ),
                    CustomHorizontalSpace(width: 8),
                    CustomTextWidget(
                      "(${("display_transaction_number").tr()})",
                      fontColor: AppColor.orange800,
                      fontSize: 12.0,
                      textAlign: TextAlign.start,
                      height: 1.3,
                    ),
                  ],
                ),
              ),
              FieldData(
                title: ("objection_details_service").tr(),
                subTitle: state.details?.serviceName,
              ),
              FieldData(
                title: ("objection_details_request_type").tr(),
                subTitle: state.details?.objectionServiceName,
              ),
              FieldData(
                title: ("objection_details_request_data").tr(),
                subTitle: state.details?.getRequestSubmitDate ?? "",
              ),
              FieldData(
                title: ("objection_details_request_update").tr(),
                subTitle: state.details?.getLastUpdatedDate,
              ),
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
            title: ("objection_details_submitter_data").tr(),
            children: [
              FieldData(
                title: ("objection_details_submitter_id"),
                subTitle: state.details?.requestSubmitterData?.id,
              ),
              FieldData(
                title: ("objection_details_submitter_name"),
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
            title: ("objection_details_commite").tr(),
            children: [
              FieldData(
                title: ("objection_details_commite_desc").tr(),
                subTitle: state.details?.committeeDecision?.decision,
              ),
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
                          title: " سبب ${index + 1}",
                          subTitle: state.details?.objectionReasonsList?[index]
                                  .reason ??
                              "",
                        ),
                        //  FieldData(
                        //  horizontalPadding: Constants.smallPadding,
                        //  title: "المرفق",
                        //    subtitleWidget:
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
                              return ObjectionAttachmentItem(
                                  file: state
                                      .details!
                                      .objectionReasonsList![index]
                                      .reasonAttachment![i]);
                            },
                          ),
                        ),
                        //  ),
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
