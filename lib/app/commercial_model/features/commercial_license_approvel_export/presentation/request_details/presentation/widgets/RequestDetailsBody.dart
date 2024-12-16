import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/attachment_show_widget.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/data/models/commercial_license_details_model.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/presentation/bloc/request_commercial_license_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../bloc/commercial_license_details_bloc.dart';

class RequestDetailsBody extends StatefulWidget {
  const RequestDetailsBody({super.key});

  @override
  State<RequestDetailsBody> createState() =>
      _RequestDetailsBodyState();
}

class _RequestDetailsBodyState
    extends State<RequestDetailsBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CommercialLicenseDetailsBloc bloc =
    context.watch<CommercialLicenseDetailsBloc>();

    // CustomTextWidget(
    //   '#${license.licenseNumber}'.tr(),
    //   textStyle: AppStyle.requestNumberTextStle,
    // )
    return BlocConsumer<CommercialLicenseDetailsBloc,
        CommercialLicenseDetailsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (_, state) async {
        if (state.status == BlocRequestStatus.submissionGetFailure) {
          MessageDialog.showErrorNotification(msg: state.error??"");
        }
      },
      builder: (context, state) {
        if (state.status == BlocStatus.loading) {
          return ListView.builder(
            itemCount: 3,
            itemBuilder: (_, __) => Container(
              height: 200,
              margin: const EdgeInsets.only(top: 16),
              child: const ShimmerEffectWidget(),
            ),
          );
        } else if (state.requestDetails != null) {
          final requestCommercialLicenseDetails =
          state.requestDetails!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    const DrawIconBasedTypeWidget(
                      icon: IconPath.calendar,
                      iconSize: 24,
                    ),
                    const SizedBox(width: 4),
                    CustomTextWidget(
                      requestCommercialLicenseDetails.creationDate ??"",
                      textStyle: AppStyle.dateTextStyle,
                    ),
                    const Spacer(),
                    Container(
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColor.primary50Light,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            CustomTextWidget(
                              requestCommercialLicenseDetails.requestStatus?.name??"",
                              textStyle: AppStyle.tagTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ExpandableCard(
                  title: 'request_data'.tr(),
                  icon: IconPath.editIcon,
                  isExpandedByDefault: true,
                  children: [
                    CardParameter(
                      title: 'request_no'.tr(),
                      value:
                      requestCommercialLicenseDetails.requestId.toString(),
                    ),
                    CardParameter(
                      title: 'request_type'.tr(),
                      value: requestCommercialLicenseDetails.requestType?.name??"",
                    ),
                    CardParameter(
                      title: 'license_type'.tr(),
                      value: "dashboardCommercialLicenseWord".tr(),
                    ),
                    CardParameter(
                      title: 'sub_municipality'.tr(),
                      value:
                      requestCommercialLicenseDetails.location?.municipality?.name??"",
                    ),
                    /////////////////////
                    // CardParameter(
                    //   title: 'objection_last_update'.tr(),
                    //   value: requestCommercialLicenseDetails.lastUpdateDate
                    //       ?.toWrittenDate() ??
                    //       "",
                    // ),

                    // requestCommercialLicenseDetails.cancellationReasonName !=
                    //     null
                    //     ? CardParameter(
                    //   title: 'reason_cancellation'.tr(),
                    //   value: requestCommercialLicenseDetails
                    //       .cancellationReasonName!,
                    // )
                    //     : const SizedBox(),


                  ],
                ),

                /////////////////////////////////////////////////
                /////////////////////////////////////////////////
                ExpandableCard(
                  title: 'responses_request'.tr(),
                  icon: IconPath.notificationStatusIcon,
                  children: [
                    requestCommercialLicenseDetails.notes != null
                        ? ListView.builder(
                      itemCount: requestCommercialLicenseDetails
                          .notes!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        RequestNotesInfo requestNotesInfo =
                        requestCommercialLicenseDetails
                            .notes![index];
                        return Card(
                          color: AppColor.primary100Light,
                          margin: const EdgeInsets.only(top: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomTextWidget(
                                      ('notes_').tr(),
                                      fontSize: 12,
                                      fontColor: AppColor.primary900Light,
                                      fontWeight: AppFontWeight.bold,
                                      textAlign: TextAlign.center,
                                    ),
                                    const Spacer(),
                                    CustomTextWidget(
                                      requestNotesInfo.date
                                          .toWrittenDate(),
                                      fontSize: 12,
                                      fontColor:
                                      AppColor.blackModern500Light,
                                      fontWeight: AppFontWeight.bold,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                CustomTextWidget(
                                  requestNotesInfo.note,
                                  fontSize: 12,
                                  maxLines: 100,
                                  fontColor: AppColor.blackModern600Light,
                                  fontWeight: AppFontWeight.regular,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                        : const SizedBox()
                  ],
                ),
                /////////////////////////////////////////////////
                const SizedBox(height: 24),
              ],
            ),
          );
        }
        return Center(
          child: ReloadWidget(
            onTab: () {
              bloc.getCommercialRequestData();
            },
          ),
        );
      },
    );
  }

// List<AttachmentData> getNewModelList(List<AttachmentModel> attachments) {
//   return attachments
//       .map(
//         (attachment) => AttachmentData(
//           id: attachment.id.toString(),
//           memo: "attachment",
//           title: attachment.name ?? '',
//           fileName: attachment.fileName ?? attachment.name,
//           filePath: attachment.attachUrl,
//           isRequired: attachment.isMandatory ?? false,
//           isUploaded: attachment.updatable ?? false,
//         ),
//       )
//       .toList();
// }
}
