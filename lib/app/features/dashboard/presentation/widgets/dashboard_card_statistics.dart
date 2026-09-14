import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_card_entity.dart';
import 'package:balady_plus/app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_core/dashboard_profile_features/dashboard/domain/entities/dashboard_card_entity.dart';
// import 'package:shared_core/dashboard_profile_features/dashboard/presentation/bloc/dashboard_bloc.dart';
// import 'package:shared_core/shared_core/_shared_feature_/app_colors.dart';
// import 'package:shared_core/shared_core/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
// import 'package:shared_core/shared_core/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
// import 'package:shared_core/shared_core/enums/bloc_status.dart';

class DashboardCardStatistics extends StatelessWidget {
  final DashboardCardEntity card;

  const DashboardCardStatistics({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          previous.cardsStates[card]?.statisticsStatuses != current.cardsStates[card]?.statisticsStatuses,
      builder: (context, state) {
        final status = state.cardsStates[card]?.statisticsStatuses;
        if (status != BlocRequestStatus.submissionGetLoading && status != BlocRequestStatus.submissionGetSuccess) {
          return const SizedBox.shrink();
        }
        final statistics = state.cardsStates[card]?.statistics;
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: statistics?.length ?? 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final statistic = statistics?[index];
              if (status == BlocRequestStatus.submissionGetLoading || statistic == null) {
                return const ShimmerEffectWidget();
              }
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      statistic.count.toString(),
                      textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: countColor(index, context)),
                    ),
                    const SizedBox(height: 8),
                    CustomTextWidget(statistic.keyName, textStyle: Theme.of(context).textTheme.labelLarge),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Color countColor(int index, context) {
    switch (index) {
      case 0:
        return Theme.of(context).primaryColor;
      case 1:
        return Theme.of(context).primaryColor.withValues(alpha: 0.8);
      case 2:
        return Theme.of(context).primaryColor.withValues(alpha: 0.6);
      case 3:
        return Theme.of(context).primaryColor.withValues(alpha: 0.4);
      default:
        return Theme.of(context).primaryColor;
    }
  }
}
