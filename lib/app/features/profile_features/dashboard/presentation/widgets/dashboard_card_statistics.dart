import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, BlocRequestStatus;
import '../../dashboard_exports.dart'
    show DashboardBloc, DashboardCardEntity, DashboardState;

class DashboardCardStatistics extends StatelessWidget {
  final DashboardCardEntity card;

  const DashboardCardStatistics({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          previous.cardsStates[card]?.statisticsStatuses !=
          current.cardsStates[card]?.statisticsStatuses,
      builder: (context, state) {
        final status = state.cardsStates[card]?.statisticsStatuses;
        if (status != BlocRequestStatus.submissionGetLoading &&
            status != BlocRequestStatus.submissionGetSuccess) {
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
              if (status == BlocRequestStatus.submissionGetLoading ||
                  statistic == null) {
                return const ShimmerEffectWidget();
              }
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColor.primary50Light40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      statistic.count.toString(),
                      textStyle: AppStyle.dashboardStatisticsCountTextStle
                          .copyWith(color: countColor(index)),
                    ),
                    const SizedBox(height: 8),
                    CustomTextWidget(
                      statistic.keyName,
                      textStyle: AppStyle.dashboardStatisticsTitleTextStle,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Color countColor(int index) {
    switch (index) {
      case 0:
        return AppColor.primary900Light;
      case 1:
        return AppColor.macaroniAndCheese;
      case 2:
        return AppColor.secondary800Light;
      case 3:
        return AppColor.blue900Light;
      default:
        return AppColor.primary900Light;
    }
  }
}
