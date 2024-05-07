import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../commercial_license_details/data/models/commercial_licence_details.dart';

class OwnershipTransferLicenseInfo extends StatelessWidget {
  final LicenseInfo? licenseInfo;
  final String crNumber;

  const OwnershipTransferLicenseInfo({
    super.key,
    required this.licenseInfo,
    required this.crNumber,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'license_info'.tr(),
      icon: IconPath.editIcon,
      isExpandedByDefault: true,
      children: [
        CardParameter(
          title: 'license_no'.tr(),
          value: licenseInfo?.licenseId.toString() ?? '',
        ),
        // CardParameter(
        //   title: 'license_shop_name'.tr(),
        //   value: commercialRequestDetails.shopInfo?.shopName?.toString() ?? '',
        // ),
        CardParameter(
          title: 'license_end_date'.tr(),
          value: licenseInfo?.licenseEndDate ?? "",
        ),
        CardParameter(
          title: 'issue_commercial_conclusion_owner_data_cr'.tr(),
          value: crNumber ?? "",
        ),
      ],
    );
  }
}
