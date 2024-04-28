import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../commercial_license_details/data/models/commercial_licence_details.dart';

class ConclusionActivityInfoWidget extends StatelessWidget {
  final ActivityInfo? activityInfo;
  final double? mainActivityArea;

  const ConclusionActivityInfoWidget({
    super.key,
    required this.activityInfo,
    required this.mainActivityArea,
  });


  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'issue_commercial_conclusion_activity_data'.tr(),
      icon: IconPath.editIcon,
      children: [
        CardParameter(
          title: 'issue_commercial_conclusion_activity_data_isic'.tr(),
          value: activityInfo?.mainActivity?.isicActivityName ?? '',
        ),
        CardParameter(
          title: 'issue_commercial_conclusion_activity_data_detailed'.tr(),
          value: activityInfo?.mainActivity?.detailedActivityName ?? '',
        ),
        CardParameter(
          title: 'issue_commercial_conclusion_activity_data_area'.tr(),
          value: activityInfo?.mainActivity?.area.toString() ?? '',
        ),
        CardParameter(
          title: 'issue_commercial_conclusion_activity_data_main_area'.tr(),
          value: mainActivityArea?.toString() ?? '',
        ),
        CardParameter(
          title: 'issue_commercial_conclusion_activity_data_marsom'.tr(),
          value: activityInfo?.mainActivity?.mainActivityName?.toString() ?? '',
        ),
        CardParameter(
          title: 'issue_commercial_conclusion_activity_facility'.tr(),
          value: activityInfo?.mainActivity?.facilityName ?? '',
        ),
        CardParameter(
          title: 'issue_commercial_conclusion_activity_worker'.tr(),
          value: activityInfo?.workerTypeName ?? '',
        ),

        /////////// if The حالة أنشطة االيواء
        activityInfo?.mainActivity?.accommodationTypeName != null
            ? CardParameter(
                title:
                    'issue_commercial_conclusion_activity_accomadate_type'.tr(),
                value: activityInfo?.mainActivity!.accommodationTypeName ?? '',
              )
            : const SizedBox(),
        activityInfo?.mainActivity?.unitCount != null
            ? CardParameter(
                title:
                    'issue_commercial_conclusion_activity_accomadate_unit'.tr(),
                value: activityInfo?.mainActivity!.unitCount.toString() ?? '',
              )
            : const SizedBox(),
      ],
    );
  }
}
