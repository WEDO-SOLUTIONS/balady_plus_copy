import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_details/calendar_event_item.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/bloc/events_list_cubit.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/widgets/list_items_events_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class BaladyCalendarEventsWidget extends StatelessWidget {
  const BaladyCalendarEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    EventsListCubit bloc = context.watch<EventsListCubit>();
    return BlocBuilder<EventsListCubit, EventsListState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is InitialEventsListState ||
            state is LoadingEventsListState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is FailureEventsListState) {
          return ReloadWidget(
            onTab: () => bloc.getCommercialLicenseDetailsById(bloc.params),
          );
        }

        /////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////
        if (state is SucceedEventsListState) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              List<CalendarEventItem>? listEvents =
                  state.event[state.listMonths[index].month ?? 0];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          bloc.params.hijri
                              ? 'month_${state.listMonths[index].month}'.tr()
                              : 'month${state.listMonths[index].month}'.tr(),
                        ),
                        Text('(${state.listMonths[index].eventsCount ?? 0})')
                      ],
                    ),
                  ),
                  listEvents != null
                      ? ListItemsEventsWidget(listEvents: listEvents)
                      : const SizedBox(),
                ],
              );
            },
            // controller: ,
            itemCount: state.listMonths.length,
          );
        }

        // View Loading In after list item in list
        if (state is SucceedWithPaginationEventsListState) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    List<CalendarEventItem>? listEvents =
                        state.event[state.listMonths[index].month ?? 0];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                bloc.params.hijri
                                    ? 'month_${state.listMonths[index].month}'
                                        .tr()
                                    : 'month${state.listMonths[index].month}'
                                        .tr(),
                              ),
                              Text(
                                '(${state.listMonths[index].eventsCount ?? 0})',
                              )
                            ],
                          ),
                        ),
                        listEvents != null
                            ? ListItemsEventsWidget(listEvents: listEvents)
                            : const SizedBox(),
                      ],
                    );
                  },
                  // controller: ,
                  itemCount: state.listMonths.length,
                ),
              ),
              const Center(child: CircularProgressIndicator())
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
