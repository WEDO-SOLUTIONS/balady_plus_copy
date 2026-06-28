import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_card_entity.dart';
import 'package:flutter/material.dart';

//!
class DashboardCardWidget extends StatelessWidget {
  final DashboardCardEntity card;
  final int totalCount;

  const DashboardCardWidget({super.key, required this.card, required this.totalCount});

  @override
  Widget build(BuildContext context) {
    Color? textColor;

    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).cardColor),
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
              fontColor: textColor ?? Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          Flexible(
            flex: 2,
            child: CustomTextWidget(
              card.name,
              fontSize: 14,
              maxLines: 4,
              height: 1.3,
              fontColor: textColor ?? Theme.of(context).primaryColor,
              textAlign: TextAlign.center,
              fontWeight: AppFontWeight.regular,
            ),
          ),
        ],
      ),
    );
  }
}
