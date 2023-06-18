import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget;
import '../../dashboard_exports.dart'
    show DashboardCardEntity, DashboardProductDropDown;
import 'dashboard_card_statistics.dart';

class DashboardCard extends StatelessWidget {
  final DashboardCardEntity card;

  const DashboardCard({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColor.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              DrawIconBasedTypeWidget(icon: cardIcon),
              const SizedBox(width: 4),
              Expanded(
                child: CustomTextWidget(
                  card.name,
                  textStyle: AppStyle.cardTitleTextStle,
                ),
              ),
              DashboardProductDropDown(card: card),
            ],
          ),
          DashboardCardStatistics(card: card),
        ],
      ),
    );
  }

  String get cardIcon {
    switch (card.id) {
      case 1:
        return IconPath.requests;
      case 2:
        return IconPath.licenses;
      default:
        return IconPath.billIcon;
    }
  }
}
