import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AdditionalActivitiesInfoWidget extends StatelessWidget {
  final List? additionalActivities;

  const AdditionalActivitiesInfoWidget(
      {super.key, required this.additionalActivities});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'list_additional_activities'.tr(),
      icon: IconPath.editIcon,
      children: [
        Column(
          children: additionalActivities
                  ?.map(
                    (e) => Card(
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          CardParameter(
                            title: 'isicActivityName_sub'.tr(),
                            value: e['isicActivityName'],
                          ),
                          CardParameter(
                            title: 'detailedActivityName'.tr(),
                            value: e['detailedActivityName'],
                          ),
                          CardParameter(
                            title: 'isicActivity_area'.tr(),
                            value: e['area'].toString(),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList() ??
              [Text("municipalAdvisorNoAdditionalActivities".tr())],
        ),
      ],
    );
  }
}
