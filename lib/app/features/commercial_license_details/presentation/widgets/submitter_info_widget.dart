import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../commercial_license_details/data/models/commercial_licence_details.dart';

class SubmitterInfoWidget extends StatelessWidget {
  final SubmitterInfo? submitterInfo;
  const SubmitterInfoWidget({super.key, required this.submitterInfo});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'issue_commercial_conclusion_applicant_data'.tr(),
      icon: IconPath.editIcon,
      isExpandedByDefault: true,
      children: [
        CardParameter(
          title: 'issue_commercial_conclusion_applicant_data_name'.tr(),
          value: submitterInfo?.submitterName ?? '',
        ),
        // need to confirm from backend and basins
        CardParameter(
          title: 'issue_commercial_conclusion_applicant_data_id'.tr(),
          value: submitterInfo?.submitterIdNumber ?? "",
        ),
        CardParameter(
          title: 'issue_commercial_conclusion_applicant_data_type'.tr(),
          value: submitterInfo?.submitterType?.toString().tr() ?? "",
        ),
      ],
    );
  }
}

