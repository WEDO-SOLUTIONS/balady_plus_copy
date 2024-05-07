import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../commercial_license_details/data/models/commercial_licence_details.dart';

class CleanContractInfoWidget extends StatelessWidget {
  final CleanContractInfo? cleanContractInfo;

  const CleanContractInfoWidget({super.key, required this.cleanContractInfo});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'issue_commercial_clean_data'.tr(),
      icon: IconPath.editIcon,
      children: [

        CardParameter(
          title: 'cleanOptionName'.tr(),
          value: cleanContractInfo?.cleanOptionName ?? "",
        ),
        cleanContractInfo?.contractOption == "SERVICE"
            ? CardParameter(
                title: 'contract_number'.tr(),
                value: cleanContractInfo?.contractNumber?.toString() ?? '',
              )
            : const SizedBox(),
        cleanContractInfo?.cleanOption != "BALADIA_SADAD"
            ? CardParameter(
                title: 'contract_expiry_date'.tr(),
                value: cleanContractInfo?.cleanContractEndDate ?? '',
              )
            : const SizedBox(),
      ],
    );
  }
}
