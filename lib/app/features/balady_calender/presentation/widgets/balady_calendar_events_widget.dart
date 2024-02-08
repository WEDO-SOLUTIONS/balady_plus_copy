import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/bloc/events_list_cubit.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/widgets/balady_calendar_month_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaladyCalendarEventsWidget extends StatelessWidget {
  const BaladyCalendarEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    EventsListCubit bloc = context.watch<EventsListCubit>();
    ScrollController scrollController = ScrollController();
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

        // View Loading In after list item in list
        if (state is SucceedWithPaginationEventsListState) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index == state.listMonths.length
                  ? const Center(child: CircularProgressIndicator())
                  : BaladyCalendarMonthWidget(
                      month: state.listMonths[index],
                      eventOfMonth: state.event[state.listMonths[index].month],
                    );
            },
            controller: scrollController
              ..addListener(
                () {
                  if (scrollController.position.pixels ==
                      scrollController.position.maxScrollExtent) {
                    bloc.getCommercialLicenseDetailsById(bloc.params);
                  }
                },
              ),
            itemCount: state.listMonths.length + 1,
          );
        }

        if (state is SucceedEventsListState) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return BaladyCalendarMonthWidget(
                month: state.listMonths[index],
                eventOfMonth: state.event[state.listMonths[index].month],
              );
            },
            itemCount: state.listMonths.length,
          );
        }

        return const SizedBox();
      },
    );
  }
}
