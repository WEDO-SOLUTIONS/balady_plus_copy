import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../commercial_license_details/data/models/commercial_licence_details.dart';

class OwnerShipInfoWidget extends StatelessWidget {
  final OwnershipInfo ownershipInfo;

  const OwnerShipInfoWidget({super.key, required this.ownershipInfo});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'issue_commercial_location'.tr(),
      icon: IconPath.editIcon,
      isExpandedByDefault: true,
      children: [
        CardParameter(
          title: 'issue_commercial_location_type'.tr(),
          value: ownershipInfo.contractType?.name ?? '',
        ),
        ownershipInfo.contractType?.id == "EJAR_ATTACH" ||  ownershipInfo.contractType?.id == "عقد تملك المبني (الصك) مرفق"
            ? CardParameter(
                title: 'issue_commercial_location_type_tenancy_date'.tr(),
                value: ownershipInfo.tenancyContractInfo?.contractEndDate ?? '',
              )
            : const SizedBox(),



        ownershipInfo.contractType?.id != "عقد استثمار الكتروني"
            ? CardParameter(
                title: 'issue_commercial_location_type_tenancy_no'.tr(),
                value:
                    ownershipInfo.tenancyContractInfo?.tenancyContractNumber ??
                        '',
              )
            : const SizedBox(),
        ownershipInfo.contractType?.id == "عقد ايجار الكتروني"
            ? CardParameter(
                title: 'issue_commercial_location_type_tenancy_ve'.tr(),
                value: ownershipInfo.tenancyContractInfo?.versionNumber ?? '',
              )
            : const SizedBox(),
      ],
    );
  }
}
