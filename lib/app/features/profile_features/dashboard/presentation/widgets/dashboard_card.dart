import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, BlocRequestStatus, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget;
import '../../dashboard_exports.dart'
    show
        DashboardBloc,
        DashboardCardEntity,
        DashboardProductDropDown,
        DashboardState,
        NoDataWidget;
import 'dashboard_card_statistics.dart';

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
        String name = state.cardsStates[card]?.statisticsStatuses ==
                BlocRequestStatus.submissionGetSuccess
            ? "${card.name} (${state.cardsStates[card]?.totalCount})"
            : card.name;

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
                            style: AppStyle.cardTitleTextStle,
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
              state.cardsStates[card]?.totalCount == 0
                  ? const NoDataWidget()
                  : DashboardCardStatistics(card: card),
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
