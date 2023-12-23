import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../profile_features/dashboard/domain/entities/dashboard_card_entity.dart';

class DashboardCard extends StatelessWidget {
  final DashboardCardEntity card;
  final int totalCount;
  const DashboardCard(
      {super.key, required this.card, required this.totalCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Color(0xffF5F7FA)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: CustomTextWidget(
              totalCount.toString(),
              fontSize: 21,
              fontWeight: AppFontWeight.bold,
              fontColor: const Color(0xff359748),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Flexible(
            flex: 2,
            child: CustomTextWidget(
              card.name,
              fontSize: 14,
              maxLines: 4,
              height: 1.3,
              textAlign: TextAlign.center,
              fontWeight: AppFontWeight.regular,
              fontColor: const Color(0xff1E2A36),
            ),
          ),
        ],
      ),
    );
  }
}
