import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/mvvm/commercial_license_attachments_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/additional%D9%80activities_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/attachment_show_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/boards_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/clean_contract_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/commercial_license_permits_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/conclusion_activity_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/license_owner_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/location_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/owner_ship_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/salama_details_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/shop_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/submitter_info_widget.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/comliance_request_details_model.dart';
import 'package:flutter/material.dart';
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
          LicenseOwnerInfoWidget(
            currentCrName: commercialLicenceDetails.submitterInfo?.entityName ?? "",
            currentCrNumber: commercialLicenceDetails.submitterInfo?.crNumber ?? "",
          ),
          ///////////////  Submitter Info
          SubmitterInfoWidget(
            submitterInfo: commercialLicenceDetails.submitterInfo,
          ),
          ////////////////    activityInfo
          ConclusionActivityInfoWidget(
            activityInfo: commercialLicenceDetails.activityInfo,
            mainActivityArea: commercialLicenceDetails.mainActivityArea ?? 0.0,
          ),
          /////////////// Additional Activities

          AdditionalActivitiesInfoWidget(
            additionalActivities:
                commercialLicenceDetails.activityInfo?.additionalActivities,
          ),
          /////////////// License Permits
          const CommercialLicensePermitsWidget(),
          /////////////// locationInfo
          LocationInfoWidget(
            locationInfo: commercialLicenceDetails.locationInfo,
          ),
          /////////////// shopInfo
          ShopInfoWidget(
            shopInfo: commercialLicenceDetails.shopInfo,
          ),
          ///////////////  Clean Contract Info
          CleanContractInfoWidget(
            cleanContractInfo:
                commercialLicenceDetails.cleanContractInfo,
          ),
          /////////////// Boards Info
          BoardsInfoWidget(
            boardsInfo: commercialLicenceDetails.shopInfo?.boardsInfo,
          ),
          ///////////////  owner Ship Info  -> بيانات اثبات الموقع
          OwnerShipInfoWidget(
            ownershipInfo: commercialLicenceDetails.ownershipInfo,
          ),
          ///////////////  Salama Details Info ->
          SalamaDetailsInfoWidget(
            salamaDetailsInfo: commercialLicenceDetails.salamaDetailsInfo,
          ),
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
