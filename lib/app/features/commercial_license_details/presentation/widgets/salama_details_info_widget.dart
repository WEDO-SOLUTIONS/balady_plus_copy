import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../commercial_license_details/data/models/commercial_licence_details.dart';

class SalamaDetailsInfoWidget extends StatelessWidget {
  final SalamaDetailsInfo? salamaDetailsInfo;

  const SalamaDetailsInfoWidget({super.key, required this.salamaDetailsInfo});

  @override
  Widget build(BuildContext context) {

    return ExpandableCard(
      title: 'issue_commercial_civil'.tr(),
      icon: IconPath.editIcon,
      children: [
        CardParameter(
          title: 'fire_approval_type'.tr(),
          value: salamaDetailsInfo?.documentName ?? '',
        ),
        ///////////////////
        salamaDetailsInfo?.documentDesc?.toString().isNotEmpty ?? false
            ? CardParameter(
                title: '',
                value: salamaDetailsInfo?.documentDesc ?? "",
              )
            : const SizedBox.shrink(),
        salamaDetailsInfo?.salamaBillNumber != null
            ? CardParameter(
                title: 'salamaBillNumber_2'.tr(),
                value: salamaDetailsInfo?.salamaBillNumber.toString() ?? '',
              )
            : const SizedBox(),
        salamaDetailsInfo?.salamaPermitNumber != null
            ? CardParameter(
                title: 'issue_commercial_civil_permit'.tr(),
                value: salamaDetailsInfo?.salamaPermitNumber.toString() ?? '',
              )
            : const SizedBox(),
        salamaDetailsInfo?.salamaReportNumber != null
            ? CardParameter(
                title: 'slamaReportNumber'.tr(),
                value: salamaDetailsInfo?.salamaReportNumber.toString() ?? '',
              )
            : const SizedBox(),
      ],
    );
  }
}
