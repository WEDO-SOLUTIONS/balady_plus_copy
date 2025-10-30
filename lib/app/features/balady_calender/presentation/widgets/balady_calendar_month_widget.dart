import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_months/months_events_count.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_details/calendar_event_item.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/bloc/events_list_cubit.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/widgets/list_items_events_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class BaladyCalendarMonthWidget extends StatelessWidget {
  final List<CalendarEventItem>? eventOfMonth;
  final MonthsEventsCount month;

  const BaladyCalendarMonthWidget({
    super.key,
    required this.month,
    required this.eventOfMonth,
  });

  @override
  Widget build(BuildContext context) {
    EventsListCubit bloc = context.watch<EventsListCubit>();
    return Column(
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bloc.params.commonParams.commonParams.hijri
                    ? 'month_${month.month}'.tr()
                    : 'month${month.month}'.tr(),
                style: AppStyle.blackTextStyle,
              ),
              Text(
                '(${month.eventsCount ?? 0})',
                style: AppStyle.blackTextStyle,
              )
            ],
          ),
        ),
        eventOfMonth != null
            ? ListItemsEventsWidget(listEvents: eventOfMonth!)
            : const SizedBox(),
      ],
    );
  }
}
