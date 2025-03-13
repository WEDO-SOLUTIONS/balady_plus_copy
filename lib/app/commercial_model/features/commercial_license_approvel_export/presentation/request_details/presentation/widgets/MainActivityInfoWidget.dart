import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../data/models/initialApproval/request_details_model.dart';


class MainActivityInfoWidget extends StatelessWidget {
  final Activities? activityInfo;



   MainActivityInfoWidget({
    super.key,
    required this.activityInfo,
  });


  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'issue_commercial_conclusion_activity_data'.tr(),
      icon: IconPath.editIcon,
      children: [
        CardParameter(
          title: 'issue_commercial_conclusion_activity_data_isic'.tr(),
          value: activityInfo?.mainActivity?.isicName ?? '',
        ),
        CardParameter(
          title: 'issue_commercial_conclusion_activity_data_detailed'.tr(),
          value: activityInfo?.mainActivity?.detailedActivityName ?? '',
        ),
        CardParameter(
          title: 'issue_commercial_conclusion_activity_data_area'.tr(),
          value: activityInfo?.shopArea.toString() ?? '',
        ),
        CardParameter(
          title: 'issue_commercial_conclusion_activity_data_main_area'.tr(),
          value: activityInfo?.mainActivity?.area?.toString() ?? '',
        ),
        // CardParameter(
        //   title: 'issue_commercial_conclusion_activity_data_marsom'.tr(),
        //   value: activityInfo?.mainActivity?.mainActivityName?.toString() ?? '',
        // ),
        CardParameter(
          title: 'issue_commercial_conclusion_activity_facility'.tr(),
          value: activityInfo?.facility?.name ?? '',
        ),
        CardParameter(
          title: 'issue_commercial_conclusion_activity_worker'.tr(),
          value: activityInfo?.workerType?.name ?? '',
        ),

        /////////// if The حالة أنشطة االيواء
        activityInfo?.accommodationType != null
            ? CardParameter(
          title:
          'issue_commercial_conclusion_activity_accomadate_type'.tr(),
          value: activityInfo?.accommodationType!.name ?? '',
        )
            : const SizedBox(),
        activityInfo?.unitCount != null
            ? CardParameter(
          title:
          'issue_commercial_conclusion_activity_accomadate_unit'.tr(),
          value: activityInfo?.unitCount.toString() ?? '',
        )
            : const SizedBox(),
      ],
    );
  }
}
