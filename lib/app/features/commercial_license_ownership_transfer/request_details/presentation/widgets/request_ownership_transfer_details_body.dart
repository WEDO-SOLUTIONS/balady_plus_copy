import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/commercial_license_cancel/mvvm/commercial_license_attachments_view_model.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/additional%D9%80activities_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/attachment_show_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/boards_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/clean_contract_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/conclusion_activity_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/license_owner_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/location_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/salama_details_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/shop_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/submitter_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/presentation/bloc/request_ownership_transfer_details_cubit.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/presentation/mvvm/selected_permits_view_model.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/presentation/widgets/ownership_transfer_license_info.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/presentation/widgets/selected_commercial_license_permits_widget.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/comliance_request_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class RequestOwnershipTransferDetailsBody extends StatefulWidget {
  const RequestOwnershipTransferDetailsBody({super.key});

  @override
  State<RequestOwnershipTransferDetailsBody> createState() =>
      _RequestOwnershipTransferDetailsBodyState();
}

class _RequestOwnershipTransferDetailsBodyState
    extends State<RequestOwnershipTransferDetailsBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RequestOwnershipTransferDetailsCubit bloc =
        context.watch<RequestOwnershipTransferDetailsCubit>();

    return BlocConsumer<RequestOwnershipTransferDetailsCubit,
        RequestOwnershipTransferDetailsState>(
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
        } else if (state.commercialLicenceDetails != null) {
          final commercialRequestDetails = state.commercialLicenceDetails!;
          return MultiProvider(
            providers: [
              // This For Get Attachments of License by licenseId
              ChangeNotifierProvider(
                create: (BuildContext context) {
                  return CommercialLicenseAttachmentsViewModel(
                    webService: sl(),
                    licenseId: commercialRequestDetails.licenseInfo!.licenseId!,
                    accessedRequestId: commercialRequestDetails.requestId,
                  );
                },
              ),
              // This For Get Selected Permits send from sender٫
              ChangeNotifierProvider(
                create: (BuildContext context) {
                  return SelectedPermitsViewModel(
                    webService: sl(),
                    requestId: commercialRequestDetails.requestId!,
                  );
                },
              ),
            ],
            child: SingleChildScrollView(
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
                        commercialRequestDetails.creationDate
                                ?.toWrittenDate() ??
                            '',
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
                                commercialRequestDetails.statusName,
                                textStyle: AppStyle.tagTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  OwnershipTransferLicenseInfo(
                    licenseInfo: commercialRequestDetails.licenseInfo,
                    crNumber: commercialRequestDetails.currentCrNumber,
                  ),
                  ///////////////  Owner Info
                  LicenseOwnerInfoWidget(
                    currentCrName: commercialRequestDetails.currentCrName,
                    currentCrNumber: commercialRequestDetails.currentCrNumber,
                  ),
                  ///////////////  Submitter Info
                  SubmitterInfoWidget(
                    submitterInfo: commercialRequestDetails.submitterInfo,
                  ),
                  ////////////////    Activity Info
                  ConclusionActivityInfoWidget(
                    activityInfo: commercialRequestDetails.activityInfo,
                    mainActivityArea:
                        commercialRequestDetails.mainActivityArea ?? 0.0,
                  ),
                  /////////////// Boards Info
                  BoardsInfoWidget(
                    boardsInfo: commercialRequestDetails.shopInfo?.boardsInfo,
                  ),
//////////////// //////////////// //////////////// ////////////////
                  AdditionalActivitiesInfoWidget(
                    additionalActivities: commercialRequestDetails
                        .activityInfo?.additionalActivities,
                  ),
                  LocationInfoWidget(
                    locationInfo: commercialRequestDetails.locationInfo,
                  ),
                  ShopInfoWidget(
                    shopInfo: commercialRequestDetails.shopInfo,
                  ),

                  CleanContractInfoWidget(
                    cleanContractInfo:
                        commercialRequestDetails.cleanContractInfo,
                  ),

                  const SelectedCommercialLicensePermitsWidget(),
                  SalamaDetailsInfoWidget(
                    salamaDetailsInfo:
                        commercialRequestDetails.salamaDetailsInfo,
                  ),

                  /////////////////////////////////////////////////
                  Selector<CommercialLicenseAttachmentsViewModel,
                      List<AttachmentModel>>(
                    builder: (context, attachments, child) {
                      return ExpandableCard(
                        title: 'data_attachments'.tr(),
                        icon: IconPath.editIcon,
                        children: [
                          attachments.isNotEmpty
                              ? ListView.builder(
                                  itemCount: attachments.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (ctx, index) {
                                    return attachments[index].attachUrl != null
                                        ? AttachmentShowWidget(
                                            fileName:
                                                attachments[index].fileName ??
                                                    '',
                                            name: attachments[index].name ?? '',
                                            filePath:
                                                attachments[index].attachUrl!,
                                          )
                                        : const SizedBox();
                                  },
                                )
                              : Text("no_attachments".tr()),
                        ],
                      );
                    },
                    selector: (_, provider) => provider.attachments,
                  ),
                  /////////////////////////////////////////////////
                  /////////////////////////////////////////////////
                  // commercialRequestDetails.licenseInfo != null &&
                  //         (state.commercialLicenceDetails!.licenseInfo!
                  //                     .qrCodeUrl ??
                  //                 "") !=
                  //             ""
                  //     ? ExpandableCard(
                  //         title: 'quick_code'.tr(),
                  //         icon: IconPath.scannerIcon,
                  //         children: [
                  //           Image.network(
                  //             state.commercialLicenceDetails!.licenseInfo!
                  //                     .qrCodeUrl ??
                  //                 "",
                  //             fit: BoxFit.fill,
                  //             headers: {
                  //               "Authorization":
                  //                   "Bearer ${CommonProperties.token}"
                  //             },
                  //           ),

                  //           const SizedBox(height: 16),
                  //           Row(
                  //             children: [
                  //               const Icon(Icons.info),
                  //               const SizedBox(width: 4),
                  //               Flexible(
                  //                 fit: FlexFit.tight,
                  //                 child: CustomAutoSizeTextWidget(
                  //                   'scan_qr_code_message'.tr(),
                  //                   textStyle:
                  //                       AppStyle.profileSectionTitleTextStyle,
                  //                   maxLines: 3,
                  //                 ),
                  //               ),
                  //             ],
                  //           )
                  //           //
                  //         ],
                  //       )
                  //     : const SizedBox(),
                  /////////////////////////////////////////////////
                  const SizedBox(height: 200),
                ],
              ),
            ),
          );
        }
        return Center(
          child: ReloadWidget(
            onTab: () {
              bloc.getCommercialLicenseDetailsById(bloc.requestID!);
            },
          ),
        );
      },
    );
  }
}
