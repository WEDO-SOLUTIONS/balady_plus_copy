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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CommercialLicenseDetailsBody extends StatefulWidget {
  const CommercialLicenseDetailsBody({super.key});

  @override
  State<CommercialLicenseDetailsBody> createState() =>
      _CommercialLicenseDetailsBodyState();
}

class _CommercialLicenseDetailsBodyState
    extends State<CommercialLicenseDetailsBody> {
  @override
  void initState() {
    super.initState();
    // context.read<CommercialLicenseDetailsCubit>().;
  }

  @override
  Widget build(BuildContext context) {
    CommercialLicenseDetailsCubit bloc =
        context.watch<CommercialLicenseDetailsCubit>();

    // CustomTextWidget(
    //   '#${license.licenseNumber}'.tr(),
    //   textStyle: AppStyle.requestNumberTextStle,
    // )
    return BlocConsumer<CommercialLicenseDetailsCubit,
        CommercialLicenseDetailsState>(
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
          final commercialLicenceDetails = state.commercialLicenceDetails!;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (BuildContext context) {
                  return CommercialLicenseAttachmentsViewModel(
                    webService: sl(),
                    licenseId: bloc.commercialLicenseId,
                  );
                },
              ),
              ChangeNotifierProvider(
                create: (BuildContext context) {
                  return CommercialLicensePermitsViewModel(
                    webService: sl(),
                    requestId: commercialLicenceDetails.licenseInfo!.licenseId,
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
                        icon: IconPath.calender,
                        iconSize: 24,
                      ),
                      const SizedBox(width: 4),
                      CustomTextWidget(
                        commercialLicenceDetails.creationDate
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
                                commercialLicenceDetails
                                    .licenseInfo!.statusDesc,
                                textStyle: AppStyle.tagTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ExpandableCard(
                    title: 'license_info'.tr(),
                    icon: IconPath.editIcon,
                    isExpandedByDefault: true,
                    children: [
                      CardParameter(
                        title: 'cr_Number'.tr(),
                        value:
                            commercialLicenceDetails.submitterInfo?.crNumber ??
                                '',
                      ),
                      CardParameter(
                        title: 'submitterName'.tr(),
                        value: commercialLicenceDetails
                            .submitterInfo!.submitterName,
                      ),
                      // CardParameter( // from whats
                      //   title: 'applicant_adjective'.tr(),
                      //   value: "not get",
                      // ),
                      CardParameter(
                        title: 'submitterIdNumber'.tr(),
                        value: commercialLicenceDetails
                                .submitterInfo?.submitterIdNumber
                                .toString() ??
                            '',
                      ),
                      /////////////////////
                      CardParameter(
                        title: 'isicActivityName'.tr(),
                        value: commercialLicenceDetails
                                .activityInfo?.mainActivity?.isicActivityName ??
                            '',
                      ),
                      CardParameter(
                        title: 'detailedActivityName'.tr(),
                        value: commercialLicenceDetails.activityInfo!
                                .mainActivity?.detailedActivityName ??
                            '',
                      ),
                      CardParameter(
                        title: 'facilityType'.tr(),
                        value: commercialLicenceDetails
                                .activityInfo!.mainActivity?.facilityName ??
                            '',
                      ),
                      CardParameter(
                        // from whats
                        title: 'total_area_activity'.tr(),
                        value: commercialLicenceDetails.mainActivityArea
                            .toString(),
                      ),
                      CardParameter(
                        // from whats
                        title: 'basic_activity_area'.tr(),
                        value: commercialLicenceDetails.mainActivityArea
                            .toString(),
                      ),
                    ],
                  ),
                  commercialLicenceDetails.activityInfo!.additionalActivities !=
                          null
                      ? ExpandableCard(
                          title: 'list_additional_activities'.tr(),
                          icon: IconPath.editIcon,
                          children: [
                            Column(
                              children: commercialLicenceDetails
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
                  commercialLicenceDetails.locationInfo != null
                      ? ExpandableCard(
                          title: 'locationInfo'.tr(),
                          icon: IconPath.qrLocationIcon,
                          children: [
                            const SizedBox(height: 16),
                            commercialLicenceDetails.locationInfo!.latitude !=
                                        null &&
                                    commercialLicenceDetails
                                            .locationInfo!.longitude !=
                                        null
                                ? SizedBox(
                                    height: 250,
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                            double.parse(
                                                commercialLicenceDetails
                                                    .locationInfo!.latitude!),
                                            double.parse(
                                                commercialLicenceDetails
                                                    .locationInfo!.longitude!),
                                          ),
                                          zoom: 16),
                                      markers: {
                                        Marker(
                                          markerId: const MarkerId('position'),
                                          position: LatLng(
                                            double.parse(
                                                commercialLicenceDetails
                                                    .locationInfo!.latitude!),
                                            double.parse(
                                                commercialLicenceDetails
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
                              value: commercialLicenceDetails
                                  .locationInfo!.regionName,
                            ),
                            CardParameter(
                              // from whats
                              title: 'municipalityName'.tr(),
                              value: commercialLicenceDetails
                                  .locationInfo!.municipalityName,
                            ),
                            CardParameter(
                              // from whats
                              title: 'subMunicipalityName'.tr(),
                              value: commercialLicenceDetails
                                  .locationInfo!.subMunicipalityName,
                            ),
                            CardParameter(
                              title: 'district'.tr(),
                              value: commercialLicenceDetails
                                  .locationInfo!.districtName,
                            ),
                            CardParameter(
                              title: 'street'.tr(),
                              value: commercialLicenceDetails
                                  .locationInfo!.streetName,
                            ),
                            CardParameter(
                              title: 'latitude'.tr(),
                              value: commercialLicenceDetails
                                      .locationInfo!.latitude ??
                                  '',
                            ),
                            CardParameter(
                              title: 'longitude'.tr(),
                              value: commercialLicenceDetails
                                      .locationInfo!.longitude ??
                                  '',
                            ),
                          ],
                        )
                      : const SizedBox(),
                  commercialLicenceDetails.shopInfo != null
                      ? ExpandableCard(
                          title: 'plaest_data_paintings'.tr(),
                          icon: IconPath.editIcon,
                          children: [
                            CardParameter(
                              title: 'shopName'.tr(),
                              value:
                                  commercialLicenceDetails.shopInfo!.shopName ??
                                      '',
                            ),
                            CardParameter(
                              // from whats
                              title: 'shopUnitNumber'.tr(),
                              value: commercialLicenceDetails
                                  .shopInfo!.shopUnitNumber
                                  .toString(),
                            ),
                            CardParameter(
                              title: 'blockNumber'.tr(),
                              value: commercialLicenceDetails
                                  .shopInfo!.blockNumber
                                  .toString(),
                            ),
                            CardParameter(
                              title: 'holesCount'.tr(),
                              value: commercialLicenceDetails
                                  .shopInfo!.holesCount
                                  .toString(),
                            ),
                            CardParameter(
                              // from whats
                              title: 'planNumber'.tr(),
                              value: commercialLicenceDetails
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
                              value: commercialLicenceDetails
                                      .shopInfo!.floorNumber
                                      ?.toString() ??
                                  '',
                            ),
                            CardParameter(
                              title: 'floorCount'.tr(),
                              value: commercialLicenceDetails
                                  .shopInfo!.floorCount
                                  .toString(),
                            ),
                            CardParameter(
                              title: 'noOfCameras'.tr(),
                              value: commercialLicenceDetails
                                  .shopInfo!.noOfCameras
                                  .toString(),
                            ),
                            //////////////////////////////////////////
                            commercialLicenceDetails.shopInfo!.hasElevator !=
                                    null
                                ? CardParameter(
                                    title: 'hasElevator'.tr(),
                                    value: commercialLicenceDetails
                                            .shopInfo!.hasElevator!
                                        ? 'yes'.tr()
                                        : 'no'.tr(),
                                  )
                                : const SizedBox(),
                            CardParameter(
                              title: 'salamaIssueNo'.tr(),
                              value: commercialLicenceDetails
                                      .salamaInfo?.salamaIssueNo ??
                                  "",
                            ),
                            //////////////////////////////////////////
                            CardParameter(
                              title: 'slamaReportNumber'.tr(),
                              value: commercialLicenceDetails
                                      .shopInfo!.slamaReportNumber
                                      ?.toString() ??
                                  '',
                            ),
                            commercialLicenceDetails
                                        .shopInfo!.contractInfoResponseDto !=
                                    null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CardParameter(
                                        title: 'contractType'.tr(),
                                        value: commercialLicenceDetails
                                            .shopInfo!.contractInfoResponseDto!
                                            .getDisplayContractTypeName(),
                                      ),
                                      CardParameter(
                                        title: 'contractNumber'.tr(),
                                        value: commercialLicenceDetails
                                            .shopInfo!
                                            .contractInfoResponseDto!
                                            .contractNumber,
                                      ),
                                      CardParameter(
                                        title: 'contractOption'.tr(),
                                        value: (commercialLicenceDetails
                                            .shopInfo!.contractInfoResponseDto!
                                            .getDisplayCleanContractName()),
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
                  const CommercialLicensePermitsWidget(),
                  /////////////////////////////////////////////////
                  commercialLicenceDetails.licenseInfo != null
                      ? ExpandableCard(
                          title: 'quick_code'.tr(),
                          icon: IconPath.scannerIcon,
                          children: [
                            QrImageView(
                              data: state.commercialLicenceDetails!.licenseInfo!
                                      .qrCodeUrl ??
                                  "",
                              size: 240,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(Icons.info),
                                const SizedBox(width: 4),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: CustomAutoSizeTextWidget(
                                    'scan_qr_code_message'.tr(),
                                    textStyle:
                                        AppStyle.profileSectionTitleTextStyle,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            )
                            //
                          ],
                        )
                      : const SizedBox(),
                  /////////////////////////////////////////////////
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        }
        return Center(
          child: ReloadWidget(
            onTab: () {
              bloc.getCommercialLicenseDetailsById(bloc.commercialLicenseId);
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
