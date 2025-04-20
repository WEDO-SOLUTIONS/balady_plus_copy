import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';


class SubmitterInfoWidget extends StatelessWidget {
  final String? submitterName;
  final String? CRNumber;
  final String? submitterType;
  const SubmitterInfoWidget({super.key, required this.submitterName,required this.CRNumber,required this.submitterType});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'issue_commercial_conclusion_applicant_data'.tr(),
      icon: IconPath.editIcon,
      isExpandedByDefault: true,
      children: [
        CardParameter(
          title: 'issue_commercial_conclusion_applicant_data_name'.tr(),
          value: submitterName?? '',
        ),
        // need to confirm from backend and basins
        CardParameter(
          title: 'agentNumber'.tr(),
          value: CRNumber ?? "",
        ),
        CardParameter(
          title: 'issue_commercial_conclusion_applicant_data_type'.tr(),
          value: submitterType.toString().tr() ?? "",
        ),
      ],
    );
  }
}

