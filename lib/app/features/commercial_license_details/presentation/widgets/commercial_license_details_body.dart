import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/commercial_license_cancel/mvvm/commercial_license_attachments_view_model.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/bloc/commercial_license_details_cubit.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/additional%D9%80activities_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/attachment_show_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/boards_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/clean_contract_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/commercial_license_permits_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/conclusion_activity_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/license_owner_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/owner_ship_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/salama_details_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/shop_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/submitter_info_widget.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/comliance_request_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class CommercialLicenseDetailsBody extends StatelessWidget {
  final CommercialLicenceDetails commercialLicenceDetails;

  const CommercialLicenseDetailsBody({
    super.key,
    required this.commercialLicenceDetails,
  });

  @override
  Widget build(BuildContext context) {
    CommercialLicenseDetailsCubit bloc =
        context.watch<CommercialLicenseDetailsCubit>();

    // CustomTextWidget(
    //   '#${license.licenseNumber}'.tr(),
    //   textStyle: AppStyle.requestNumberTextStle,
    // )
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
                commercialLicenceDetails.creationDate?.toWrittenDate() ?? '',
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
                        commercialLicenceDetails.licenseInfo!.statusDesc ?? "",
                        textStyle: AppStyle.tagTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ///////////////  Owner Info
          commercialLicenceDetails.submitterInfo != null
              ? LicenseOwnerInfoWidget(
                  submitterInfo: commercialLicenceDetails.submitterInfo!,
                )
              : const SizedBox(),
          ///////////////  Submitter Info
          commercialLicenceDetails.submitterInfo != null
              ? SubmitterInfoWidget(
                  submitterInfo: commercialLicenceDetails.submitterInfo!,
                )
              : const SizedBox(),
          ////////////////    activityInfo
          commercialLicenceDetails.activityInfo != null
              ? ConclusionActivityInfoWidget(
                  activityInfo: commercialLicenceDetails.activityInfo,
                  mainActivityArea: commercialLicenceDetails.mainActivityArea,
                  entityType:
                      commercialLicenceDetails.submitterInfo?.entityType,
                )
              : const SizedBox(),
          /////////////// Additional Activities
          commercialLicenceDetails.activityInfo!.additionalActivities != null
              ? AdditionalActivitiesInfoWidget(
                  additionalActivities: commercialLicenceDetails
                      .activityInfo!.additionalActivities,
                )
              : const SizedBox(),
          /////////////// License Permits
          const CommercialLicensePermitsWidget(),
          /////////////// locationInfo
          commercialLicenceDetails.locationInfo != null
              ? ExpandableCard(
                  title: 'locationInfo'.tr(),
                  icon: IconPath.qrLocationIcon,
                  children: [
                    const SizedBox(height: 16),
                    commercialLicenceDetails.locationInfo!.latitude != null &&
                            commercialLicenceDetails.locationInfo!.longitude !=
                                null
                        ? SizedBox(
                            height: 250,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    double.parse(commercialLicenceDetails
                                        .locationInfo!.latitude!),
                                    double.parse(commercialLicenceDetails
                                        .locationInfo!.longitude!),
                                  ),
                                  zoom: 16),
                              markers: {
                                Marker(
                                  markerId: const MarkerId('position'),
                                  position: LatLng(
                                    double.parse(commercialLicenceDetails
                                        .locationInfo!.latitude!),
                                    double.parse(commercialLicenceDetails
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
                      value:
                          commercialLicenceDetails.locationInfo!.regionName ??
                              "",
                    ),
                    CardParameter(
                        // from whats
                        title: 'municipalityName'.tr(),
                        value: commercialLicenceDetails
                                .locationInfo!.municipalityName ??
                            ""),
                    CardParameter(
                      // from whats
                      title: 'subMunicipalityName'.tr(),
                      value: commercialLicenceDetails
                              .locationInfo!.subMunicipalityName ??
                          "",
                    ),
                    CardParameter(
                      title: 'district'.tr(),
                      value:
                          commercialLicenceDetails.locationInfo!.districtName ??
                              "",
                    ),
                    CardParameter(
                      title: 'street'.tr(),
                      value:
                          commercialLicenceDetails.locationInfo!.streetName ??
                              "",
                    ),
                    CardParameter(
                      title: 'latitude'.tr(),
                      value:
                          commercialLicenceDetails.locationInfo!.latitude ?? '',
                    ),
                    CardParameter(
                      title: 'longitude'.tr(),
                      value: commercialLicenceDetails.locationInfo!.longitude ??
                          '',
                    ),
                  ],
                )
              : const SizedBox(),
          /////////////// shopInfo
          commercialLicenceDetails.shopInfo != null
              ? ShopInfoWidget(shopInfo: commercialLicenceDetails.shopInfo!)
              : const SizedBox(),
          ///////////////  Clean Contract Info
          commercialLicenceDetails.shopInfo?.cleanContractInfo != null
              ? CleanContractInfoWidget(
                  cleanContractInfo:
                      commercialLicenceDetails.shopInfo!.cleanContractInfo!,
                )
              : const SizedBox(),
          /////////////// Boards Info
          commercialLicenceDetails.shopInfo?.boardsInfo != null
              ? BoardsInfoWidget(
                  boardsInfo: commercialLicenceDetails.shopInfo!.boardsInfo!,
                )
              : const SizedBox(),
          ///////////////  owner Ship Info  -> بيانات اثبات الموقع
          commercialLicenceDetails.ownershipInfo != null ? OwnerShipInfoWidget(
            ownershipInfo: commercialLicenceDetails.ownershipInfo!,
          ) : const SizedBox(),
          ///////////////  Salama Details Info ->
          commercialLicenceDetails.salamaDetailsInfo != null
              ? SalamaDetailsInfoWidget(
                  salamaDetailsInfo: commercialLicenceDetails.salamaDetailsInfo!,
                )
              : const SizedBox(),
          /////////////// license_info
          // ExpandableCard(
          //   title: 'license_info'.tr(),
          //   icon: IconPath.editIcon,
          //   isExpandedByDefault: true,
          //   children: [
          //     CardParameter(
          //       title: 'cr_Number'.tr(),
          //       value: commercialLicenceDetails.submitterInfo?.crNumber ?? '',
          //     ),
          //     CardParameter(
          //       title: 'submitterName'.tr(),
          //       value:
          //           commercialLicenceDetails.submitterInfo!.submitterName ?? "",
          //     ),
          //     // CardParameter( // from whats
          //     //   title: 'applicant_adjective'.tr(),
          //     //   value: "not get",
          //     // ),
          //     CardParameter(
          //       title: 'submitterIdNumber'.tr(),
          //       value: commercialLicenceDetails.submitterInfo?.submitterIdNumber
          //               .toString() ??
          //           '',
          //     ),
          //     /////////////////////
          //     CardParameter(
          //       title: 'isicActivityName'.tr(),
          //       value: commercialLicenceDetails
          //               .activityInfo?.mainActivity?.isicActivityName ??
          //           '',
          //     ),
          //     CardParameter(
          //       title: 'detailedActivityName'.tr(),
          //       value: commercialLicenceDetails
          //               .activityInfo!.mainActivity?.detailedActivityName ??
          //           '',
          //     ),
          //     CardParameter(
          //       title: 'facilityType'.tr(),
          //       value: commercialLicenceDetails
          //               .activityInfo!.mainActivity?.facilityName ??
          //           '',
          //     ),
          //     CardParameter(
          //       // from whats
          //       title: 'total_area_activity'.tr(),
          //       value: commercialLicenceDetails.mainActivityArea.toString(),
          //     ),
          //     CardParameter(
          //       // from whats
          //       title: 'basic_activity_area'.tr(),
          //       value: commercialLicenceDetails.mainActivityArea.toString(),
          //     ),
          //   ],
          // ),
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
                                    fileName: attachments[index].fileName ?? '',
                                    name: attachments[index].name ?? '',
                                    filePath: attachments[index].attachUrl!,
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
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
