import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';


class LicenseOwnerInfoWidget extends StatelessWidget {
  final String currentCrName;
  final String currentCrNumber;

  const LicenseOwnerInfoWidget({
    super.key,
    required this.currentCrName,
    required this.currentCrNumber,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'license_owner_info'.tr(),
      icon: IconPath.editIcon,
      isExpandedByDefault: true,
      children: [
        CardParameter(
          title: 'issue_commercial_conclusion_owner_data_name'.tr(),
          value: currentCrName,
        ),
        CardParameter(
          title: 'issue_commercial_conclusion_owner_data_cr'.tr(),
          value: currentCrNumber,
        ),
      ],
    );
  }
}
