import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/commercial_license_cancel/mvvm/commercial_license_attachments_view_model.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/attachment_show_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/commercial_license_permits_widget.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/presentation/bloc/request_ownership_transfer_details_cubit.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/presentation/mvvm/selected_permits_view_model.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/presentation/widgets/selected_commercial_license_permits_widget.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/comliance_request_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
                    licenseId: commercialRequestDetails.licenseInfo!.licenseId,
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
                                commercialRequestDetails.statusName ,
                                textStyle: AppStyle.tagTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ExpandableCard(
                    title: 'license_owner_info'.tr(),
                    icon: IconPath.editIcon,
                    isExpandedByDefault: true,
                    children: [
                      CardParameter(
                        title: 'facility_name'.tr(),
                        value: commercialRequestDetails
                                .submitterInfo?.entityName ??
                            '',
                      ),
                      CardParameter(
                        title: 'issue_commercial_conclusion_owner_data_cr'.tr(),
                        value: commercialRequestDetails.submitterInfo?.crNumber ?? '',
                      ),
                    ],
                  ),
                  ExpandableCard(
                    title: 'ApplicantInfo'.tr(),
                    icon: IconPath.editIcon,
                    isExpandedByDefault: true,
                    children: [
                      CardParameter(
                        title: 'driver_card_applicant_name'.tr(),
                        value: commercialRequestDetails
                                .submitterInfo?.submitterName ??
                            '',
                      ),
                      CardParameter(
                        title: 'submitterIdNumber'.tr(),
                        value: commercialRequestDetails
                            .submitterInfo?.submitterIdNumber
                            .toString() ?? '',
                      ),
                      CardParameter(
                        title: 'applicantDesc'.tr(),
                        value: commercialRequestDetails
                            .submitterInfo?.submitterType ?? '',
                      ),
                    ],
                  ),
                  ExpandableCard(
                    title: 'issue_commercial_conclusion_activity_data'.tr(),
                    icon: IconPath.editIcon,
                    isExpandedByDefault: true,
                    children: [
                      CardParameter(
                        title: 'issue_commercial_conclusion_activity_data_isic'
                            .tr(),
                        value: commercialRequestDetails
                                .activityInfo?.mainActivity?.isicActivityName ??
                            '',
                      ),
                      CardParameter(
                        title:
                            'issue_commercial_conclusion_activity_data_detailed'
                                .tr(),
                        value: commercialRequestDetails.activityInfo
                                ?.mainActivity?.detailedActivityName ??
                            '',
                      ),
                      CardParameter(
                        title: 'issue_commercial_conclusion_activity_data_area'
                            .tr(),
                        value: commercialRequestDetails
                                .activityInfo?.mainActivity?.area
                                .toString() ??
                            '',
                      ),
                      CardParameter(
                        title:
                            'issue_commercial_conclusion_activity_data_main_area'
                                .tr(),
                        value: commercialRequestDetails.mainActivityArea
                            ?.toString() ?? '',
                      ),
                      CardParameter(
                        title:
                            'issue_commercial_conclusion_activity_data_marsom'
                                .tr(),
                        value: commercialRequestDetails.mainActivityArea?.toString() ?? '',
                      ),
                      CardParameter(
                        title: 'issue_commercial_conclusion_activity_facility'
                            .tr(),
                        value: commercialRequestDetails
                                .submitterInfo?.entityType.toString() ?? '',
                      ),
                      CardParameter(
                        title:
                            'issue_commercial_conclusion_activity_worker'.tr(),
                        value: commercialRequestDetails
                                .activityInfo?.workerTypeName ??
                            '',
                      ),
                    ],
                  ),

                  commercialRequestDetails.activityInfo!.additionalActivities !=
                          null
                      ? ExpandableCard(
                          title: 'list_additional_activities'.tr(),
                          icon: IconPath.editIcon,
                          children: [
                            Column(
                              children: commercialRequestDetails
                                  .activityInfo!.additionalActivities!
                                  .map(
                                    (e) => Card(
                                      margin: const EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          CardParameter(
                                            title: 'isicActivityName_sub'.tr(),
                                            value: e.isicActivityName,
                                          ),
                                          CardParameter(
                                            title: 'detailedActivityName'.tr(),
                                            value: e.detailedActivityName,
                                          ),
                                          CardParameter(
                                            title: 'isicActivityName'.tr(),
                                            value: e.area.toString(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        )
                      : const SizedBox(),

                  const SelectedCommercialLicensePermitsWidget(),

                  commercialRequestDetails.locationInfo != null
                      ? ExpandableCard(
                          title: 'locationInfo'.tr(),
                          icon: IconPath.qrLocationIcon,
                          children: [
                            const SizedBox(height: 16),
                            commercialRequestDetails.locationInfo!.latitude !=
                                        null &&
                                    commercialRequestDetails
                                            .locationInfo!.longitude !=
                                        null
                                ? SizedBox(
                                    height: 250,
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                            double.parse(
                                                commercialRequestDetails
                                                    .locationInfo!.latitude!),
                                            double.parse(
                                                commercialRequestDetails
                                                    .locationInfo!.longitude!),
                                          ),
                                          zoom: 16),
                                      markers: {
                                        Marker(
                                          markerId: const MarkerId('position'),
                                          position: LatLng(
                                            double.parse(
                                                commercialRequestDetails
                                                    .locationInfo!.latitude!),
                                            double.parse(
                                                commercialRequestDetails
                                                    .locationInfo!.longitude!),
                                          ),
                                        )
                                      },
                                      zoomControlsEnabled: false,
                                      zoomGesturesEnabled: false,
                                      scrollGesturesEnabled: false,
                                    ),
                                  )
                                : const SizedBox(),
                            CardParameter(
                              title: 'region'.tr(),
                              value: commercialRequestDetails
                                  .locationInfo!.regionName,
                            ),
                            CardParameter(
                              // from whats
                              title: 'municipalityName'.tr(),
                              value: commercialRequestDetails
                                  .locationInfo!.municipalityName,
                            ),
                            CardParameter(
                              // from whats
                              title: 'subMunicipalityName'.tr(),
                              value: commercialRequestDetails
                                  .locationInfo!.subMunicipalityName,
                            ),
                            CardParameter(
                              title: 'district'.tr(),
                              value: commercialRequestDetails
                                  .locationInfo!.districtName,
                            ),
                            CardParameter(
                              title: 'street'.tr(),
                              value: commercialRequestDetails
                                  .locationInfo!.streetName,
                            ),
                            CardParameter(
                              title: 'latitude'.tr(),
                              value: commercialRequestDetails
                                      .locationInfo!.latitude ??
                                  '',
                            ),
                            CardParameter(
                              title: 'longitude'.tr(),
                              value: commercialRequestDetails
                                      .locationInfo!.longitude ??
                                  '',
                            ),
                          ],
                        )
                      : const SizedBox(),

//TODO: بيانات النظافة
                  commercialRequestDetails.shopInfo?.cleanContractInfo != null
                      ? ExpandableCard(
                          title: "issue_commercial_clean_data".tr(),
                          icon: IconPath.editIcon,
                          children: [])
                      : const SizedBox(),

                  commercialRequestDetails.shopInfo != null
                      ? ExpandableCard(
                          title: 'plaest_data_paintings'.tr(),
                          icon: IconPath.editIcon,
                          children: [
                            CardParameter(
                              title: 'shopName'.tr(),
                              value:
                                  commercialRequestDetails.shopInfo!.shopName ??
                                      '',
                            ),
                            CardParameter(
                              // from whats
                              title: 'shopUnitNumber'.tr(),
                              value: commercialRequestDetails
                                  .shopInfo!.shopUnitNumber?.toString() ?? '',
                            ),
                            CardParameter(
                              title: 'blockNumber'.tr(),
                              value: commercialRequestDetails
                                  .shopInfo!.blockNumber?.toString() ?? '',
                            ),
                            CardParameter(
                              title: 'holesCount'.tr(),
                              value: commercialRequestDetails
                                  .shopInfo!.holesCount?.toString() ?? '',
                            ),
                            CardParameter(
                              // from whats
                              title: 'planNumber'.tr(),
                              value: commercialRequestDetails
                                      .shopInfo!.planNumber ??
                                  '',
                            ),
                            //////////////////////////////////////////
                            // CardParameter(
                            //   title: 'رقم القطعة'.tr(),
                            //   value: 'رقم القطعة',
                            // ),
                            //////////////////////////////////////////
                            CardParameter(
                              title: 'floorNumber'.tr(),
                              value: commercialRequestDetails
                                      .shopInfo!.floorNumber
                                      ?.toString() ??
                                  '',
                            ),
                            CardParameter(
                              title: 'floorCount'.tr(),
                              value: commercialRequestDetails
                                  .shopInfo!.floorCount?.toString() ?? '',
                            ),
                            CardParameter(
                              title: 'noOfCameras'.tr(),
                              value: commercialRequestDetails
                                  .shopInfo!.noOfCameras
                                  .toString(),
                            ),
                            //////////////////////////////////////////
                            commercialRequestDetails.shopInfo!.hasElevator !=
                                    null
                                ? CardParameter(
                                    title: 'hasElevator'.tr(),
                                    value: commercialRequestDetails
                                            .shopInfo!.hasElevator!
                                        ? 'yes'.tr()
                                        : 'no'.tr(),
                                  )
                                : const SizedBox(),
                            CardParameter(
                              title: 'salamaIssueNo'.tr(),
                              value: commercialRequestDetails
                                      .salamaInfo?.salamaIssueNo ??
                                  "",
                            ),
                            //////////////////////////////////////////
                            CardParameter(
                              title: 'slamaReportNumber'.tr(),
                              value: commercialRequestDetails
                                      .shopInfo!.slamaReportNumber
                                      ?.toString() ??
                                  '',
                            ),
                            commercialRequestDetails
                                        .shopInfo!.contractInfoResponseDto !=
                                    null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CardParameter(
                                        title: 'contractType'.tr(),
                                        value: commercialRequestDetails
                                            .shopInfo!.contractInfoResponseDto?.getDisplayContractTypeName() ?? '',
                                      ),
                                      CardParameter(
                                        title: 'contractNumber'.tr(),
                                        value: commercialRequestDetails
                                            .shopInfo!
                                            .contractInfoResponseDto?.contractNumber ?? '',
                                      ),
                                      CardParameter(
                                        title: 'contractOption'.tr(),
                                        value: (commercialRequestDetails
                                            .shopInfo!.contractInfoResponseDto?.getDisplayCleanContractName() ?? ''),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),

                            state.commercialLicenceDetails!.shopInfo
                                        ?.boardsInfo !=
                                    null
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: state.commercialLicenceDetails!
                                        .shopInfo!.boardsInfo!.length,
                                    itemBuilder: (_, index) {
                                      BoardsInfo boardsInfo = state
                                          .commercialLicenceDetails!
                                          .shopInfo!
                                          .boardsInfo![index];
                                      return Card(
                                        margin: const EdgeInsets.only(top: 16),
                                        color: AppColor.primary100Light,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomTextWidget(
                                                '${'board'.tr()} ${++index}',
                                                textStyle: AppStyle
                                                    .signInFullTextStyle
                                                    .copyWith(
                                                  color:
                                                      AppColor.primary700Light,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              CustomTextWidget(
                                                "boardTypeName".tr(),
                                                textStyle:
                                                    AppStyle.tagTextStyle,
                                              ),
                                              const SizedBox(height: 4),
                                              CustomTextWidget(
                                                boardsInfo.typeName,
                                                textStyle: AppStyle
                                                    .costTextStyle
                                                    .copyWith(
                                                  color:
                                                      const Color(0xff52525B),
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              CustomTextWidget(
                                                "boardArea".tr(),
                                                textStyle:
                                                    AppStyle.tagTextStyle,
                                              ),
                                              const SizedBox(height: 4),
                                              CustomTextWidget(
                                                boardsInfo.area.toString() +
                                                    'm2'.tr(),
                                                textStyle: AppStyle
                                                    .costTextStyle
                                                    .copyWith(
                                                  color:
                                                      const Color(0xff52525B),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const SizedBox(),
                          ],
                        )
                      : const SizedBox(),

//TODO: بيانات الدفاع المدني
                  commercialRequestDetails.salamaInfo != null
                      ? ExpandableCard(
                          title: 'issue_commercial_civil'.tr(), children: [])
                      : const SizedBox(),

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
                              : const SizedBox(),
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
