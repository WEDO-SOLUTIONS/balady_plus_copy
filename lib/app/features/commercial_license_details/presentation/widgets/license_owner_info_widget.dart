import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../commercial_license_details/data/models/commercial_licence_details.dart';

class LicenseOwnerInfoWidget extends StatelessWidget {
  final SubmitterInfo submitterInfo;
  const LicenseOwnerInfoWidget({super.key, required this.submitterInfo});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'license_owner_info'.tr(),
      icon: IconPath.editIcon,
      isExpandedByDefault: true,
      children: [
        CardParameter(
          title: 'issue_commercial_conclusion_owner_data_name'.tr(),
          value: submitterInfo.entityName ?? '',
        ),
        CardParameter(
          title: 'issue_commercial_conclusion_owner_data_cr'.tr(),
          value: submitterInfo.crNumber ?? "",
        ),
      ],
    );
  }
}

