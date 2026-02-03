import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_card_entity.dart';
import 'package:balady_plus/app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:balady_plus/app/features/dashboard/presentation/widgets/dashboard_card_statistics.dart';
import 'package:balady_plus/app/features/dashboard/presentation/widgets/dashboard_product_drop_down.dart';
import 'package:balady_plus/app/features/dashboard/presentation/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCard extends StatelessWidget {
  final DashboardCardEntity card;

  const DashboardCard({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        String name = state.cardsStates[card]?.statisticsStatuses == BlocRequestStatus.submissionGetSuccess
            ? "${card.name} (${state.cardsStates[card]?.totalCount})"
            : card.name;

        return Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(16),
          decoration:  BoxDecoration(
              color: Theme.of(context).cardColor,

              borderRadius: BorderRadius.all(Radius.circular(16)),
              ),

          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        DrawIconBasedTypeWidget(icon: cardIcon),
                        const SizedBox(width: 4),
                        Flexible(
                          child: AutoSizeText(
                            name,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: DashboardProductDropDown(
                      card: card,
                    ),
                  ),
                ],
              ),
              state.cardsStates[card]?.totalCount == 0 ? const NoDataWidget() : DashboardCardStatistics(card: card),
            ],
          ),
        );
      },
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
