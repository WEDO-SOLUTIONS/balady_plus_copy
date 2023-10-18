import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/commercial_license_cancel/mvvm/commercial_license_attachments_view_model.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/commercial_license_cancel/mvvm/commercial_license_permits_view_model.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/bloc/commercial_license_details_cubit.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/attachment_show_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/commercial_license_permits_widget.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/comliance_request_details_model.dart';
import 'package:balady_plus/app/features/request_commercial_license_details/data/models/commercial_license_details_model.dart';
import 'package:balady_plus/app/features/request_commercial_license_details/presentation/bloc/request_commercial_license_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RequestCommercialLicenseDetailsBody extends StatefulWidget {
  const RequestCommercialLicenseDetailsBody({super.key});

  @override
  State<RequestCommercialLicenseDetailsBody> createState() =>
      _RequestCommercialLicenseDetailsBodyState();
}

class _RequestCommercialLicenseDetailsBodyState
    extends State<RequestCommercialLicenseDetailsBody> {
  @override
  void initState() {
    super.initState();
    // context.read<CommercialLicenseDetailsCubit>().;
  }

  @override
  Widget build(BuildContext context) {
    RequestCommercialLicenseDetailsCubit bloc =
        context.watch<RequestCommercialLicenseDetailsCubit>();

    // CustomTextWidget(
    //   '#${license.licenseNumber}'.tr(),
    //   textStyle: AppStyle.requestNumberTextStle,
    // )
    return BlocConsumer<RequestCommercialLicenseDetailsCubit,
        RequestCommercialLicenseDetailsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (_, state) async {
        if (state.status == BlocRequestStatus.submissionGetFailure) {
          MessageDialog.showErrorNotification(msg: state.error);
        }
      },
      builder: (context, state) {
        if (state.status == BlocRequestStatus.submissionGetLoading) {
          return ListView.builder(
            itemCount: 3,
            itemBuilder: (_, __) => Container(
              height: 200,
              margin: const EdgeInsets.only(top: 16),
              child: const ShimmerEffectWidget(),
            ),
          );
        } else if (state.requestCommercialLicenseDetails != null) {
          final requestCommercialLicenseDetails =
              state.requestCommercialLicenseDetails!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    const DrawIconBasedTypeWidget(
                      icon: IconPath.calender,
                      iconSize: 24,
                    ),
                    const SizedBox(width: 4),
                    CustomTextWidget(
                      requestCommercialLicenseDetails.lastUpdateDate,
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
                              requestCommercialLicenseDetails.statusName,
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
                      title: 'license_type'.tr(),
                      value: requestCommercialLicenseDetails
                          .licenseInfo.statusName,
                    ),
                    CardParameter(
                      title: 'sub_municipality'.tr(),
                      value: requestCommercialLicenseDetails.statusName,
                    ),
                    /////////////////////
                    CardParameter(
                      title: 'objection_last_update'.tr(),
                      value: requestCommercialLicenseDetails.lastUpdateDate,
                    ),
                  ],
                ),
                requestCommercialLicenseDetails.attachmentsInfo != null
                    ? ListView.builder(
                        itemCount: requestCommercialLicenseDetails
                            .attachmentsInfo!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          return requestCommercialLicenseDetails
                                      .attachmentsInfo![index].attachUrl !=
                                  null
                              ? AttachmentShowWidget(
                                  fileName: '',
                                  name: requestCommercialLicenseDetails
                                          .attachmentsInfo![index].name ??
                                      '',
                                  filePath: requestCommercialLicenseDetails
                                      .attachmentsInfo![index].attachUrl!,
                                )
                              : const SizedBox();
                        },
                      )
                    : const SizedBox(),

                /////////////////////////////////////////////////
                /////////////////////////////////////////////////
                ExpandableCard(
                  title: 'responses_request'.tr(),
                  icon: IconPath.scannerIcon,
                  children: [
                    requestCommercialLicenseDetails.requestNotesInfo != null
                        ? ListView.builder(
                            itemCount: requestCommercialLicenseDetails.requestNotesInfo!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              RequestNotesInfo requestNotesInfo = requestCommercialLicenseDetails.requestNotesInfo![index];
                              return Column(
                                children: [
                                  Container(
                                    child: Column(
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

                                            CustomTextWidget(
                                              requestNotesInfo.date.toWrittenDate(),
                                              fontSize: 12,
                                              fontColor: AppColor.blackModern500Light,
                                              fontWeight: AppFontWeight.bold,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),

                                        CustomTextWidget(
                                          requestNotesInfo.note,
                                          fontSize: 12,
                                          fontColor: AppColor.blackModern600Light,
                                          fontWeight: AppFontWeight.regular,
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
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
              bloc.getRequestCommercialLicenseDetailsById(bloc.requestId);
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
