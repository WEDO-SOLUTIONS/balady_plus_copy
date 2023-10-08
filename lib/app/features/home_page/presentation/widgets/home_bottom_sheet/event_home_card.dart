import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../calendar/domain/entities/search_calendar/search_calendar_item.dart';
import '../../../../calendar/presentation/widgets/old_calendar_card.dart';

class EventHomeCard extends StatelessWidget {
  const EventHomeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<CalendarBloc>(),
      child: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          if (state.status == BlocStatus.loading)
            return CustomShimmerWidget(
              childHeight: 201,
            );
          if (state.status == BlocStatus.failure)
            return RetryWidget(
              onRetry: () {
                context.read<CalendarBloc>().add(GetSearchEvent());
              },
            );

          SearchCalendarItem? item = state.searchItems.firstOrNull;
          if (item == null) return Container();

          return OldCalendarCard(item: item);
        },
      ),
    );
  }
}
